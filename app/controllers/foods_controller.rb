class FoodsController < ApplicationController
  require 'json'
  require "open-uri"
  require "i18n"

  def index
    @foods = current_user.foods.reverse_order
  end

  def show
    @food = Food.find(params[:id])
    @pref_arr = current_user.preferences.split(", ")
    classify_ingredients_individually
    classify_categories
    @pref_flags = pref_flags
    @ingredients
    @unknown_ingredients
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    @food.user = current_user
    if @food.save
      @food.extract_ingredients
      @food.vegan_boolean
      @food.save
      puts "save successfull!"
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

  def classify_ingredients_individually
    # true, false, can-be, empty
    @preferences = [[], [], [], []]
    @ingredients = []
    @unknown_ingredients = []
    @pref_arr.each do |preference|
      @food.ingredient_list.split(", ").each do |ingredient|
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
    @pref_arr.each do |preference|
      if !@preferences[1].nil?
        @preferences[1].each do |ingredient|
          if (ingredient.check(preference) == "false")
            @food.update_flag(preference, "false")
          end
        end
      elsif !@preferences[2].nil? && preference[1].nil?
        if (ingredient.check(preference) == "can-be")
          @food.update_flag(preference, "can-be")
        end
      else
        @food.update_flag(preference, "true")
      end
    end
  end

  def pref_flags
    arr = []
    @pref_arr.each do |pref|
      arr << @food.check(pref)
    end
    return arr
  end
end
