class FoodsController < ApplicationController
  require 'json'
  require "open-uri"
  require "i18n"

  def index
    @foods = current_user.foods.reverse_order
  end

  def show
    @food = Food.find(params[:id])
    @ingredient_list = @food.ingredient_list.split(", ")
    @pref_arr = current_user.preferences.split(" ")
    @pref_flags
    pref_flags
    @ingredients
    @unknown_ingredients
    @false_ingredients
    @maybe_ingredients
    @true_ingredients
    get_ingredients
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    @food.user = current_user
    if @food.save
      @food.extract_ingredients
      @ingredient_list = @food.ingredient_list.split(", ")
      classify_ingredients_individually
      classify_categories
      redirect_to food_path(@food)
    else
      flash[:error] = @food.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @food = Food.find(params[:id])
    if @food.photos.attach(food_params[:photos]) || food_params[:name].present?
      @food.name = food_params[:name] if food_params[:name].present?
      @food.save
      redirect_to food_path(@food)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :ingredient_list, :vegetarian, :pescetarian, :dairy_free, :peanut_free, :vegan, photos: [])
  end

  def get_ingredients
    @ingredients = []
    @unknown_ingredients = []
    @false_ingredients = []
    @maybe_ingredients = []
    @true_ingredients = []
    @ingredient_list.each do |ingredient|
      ing = Ingredient.find_by(name: ingredient.strip)
      if !ing.nil?
        @ingredients << ing
      else
        @unknown_ingredients << ingredient
      end
    end
    @ingredients.each do |ingredient|
      if (ingredient.full_check(@pref_arr).include?("false"))
        @false_ingredients << ingredient
      elsif (ingredient.full_check(@pref_arr).include?("can-be") && !@false_ingredients.include?(ingredient))
        @maybe_ingredients << ingredient
      else
        @true_ingredients << ingredient
      end
    end
  end

  def classify_ingredients_individually
    # true, false, can-be, empty
    @preferences = [[], [], [], []]
    @ingredients = []
    @unknown_ingredients = []
    Gpt::ALL_PREFERENCES.each do |preference|
      @ingredient_list.each do |ingredient|
        ing = Ingredient.find_by(name: ingredient.strip)
        if !ing.nil?
          @ingredients << ing
          if ing.check(preference) == "true"
            @preferences[0] << ing
          elsif ing.check(preference) == "false"
            @preferences[1] << ing
          else
            @preferences[2] << ing
          end
        else
          @preferences[3] << ingredient
          @unknown_ingredients << ingredient
        end
      end
    end
    @preferences[0].uniq!
    @preferences[1].uniq!
    @preferences[2].uniq!
    @preferences[3].uniq!
    @ingredients.uniq!
    @unknown_ingredients.uniq!
  end

  def classify_categories
    Gpt::ALL_PREFERENCES.each do |preference|
      if (!@preferences[1].nil?)
        @preferences[1].each do |ingredient|
          if (ingredient.check(preference) == "false")
            @food.update_flag(preference, "false")
          end
        end
      end
      if (!@preferences[2].nil? && @food.check(preference).nil?)
        @preferences[2].each do |ingredient|
          if (ingredient.check(preference) == "can-be")
            @food.update_flag(preference, "can-be")
          end
        end
      end
      if (@food.check(preference).nil?)
        @food.update_flag(preference, "true")
      end
    end
  end

  def pref_flags
    @pref_flags = []
    @pref_arr.each do |pref|
      @pref_flags << @food.check(pref)
    end
  end
end
