class FoodsController < ApplicationController
  require 'json'
  require "open-uri"
  require "i18n"

  def index
    @foods = current_user.foods.reverse_order
  end

  def show
    @food = Food.find(params[:id])
    classify_ingredients_individually
    classify_categories
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    @food.user = current_user
    if @food.save
      @food.extract_ingredients
      # @food.translate
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
    params.require(:food).permit(:name, :ingredient_list, :vegan, photos: [])
  end

  def classify_ingredients_individually
    # current_user.preferences.each do |preference|
    if current_user.preferences.nil?
      @true_vegan_flags = []
      @can_be_vegan_flags = []
      @false_vegan_flags = []
      @food.ingredient_list.split(", ").each do |ingredient|
        ing = Ingredient.find_by(name: ingredient.strip)
        if !ing.nil?
          if ing.vegan == "true"
            @true_vegan_flags << ing
          elsif ing.vegan == "false"
            @false_vegan_flags << ing
          else
            @can_be_vegan_flags << ing
          end
        else
          @can_be_vegan_flags << ingredient
        end
      end
    else
      @preferences = current_user.preferences.split(", ")
      @preferences.each do |preference|
        preference = [
          [], [], []
        ]
        @food.ingredient_list.split(", ").each do |ingredient|
          ing = Ingredient.find_by(name: ingredient.strip)
          if !ing.nil?
            if ing.check(preference) == "true"
              preference[0] << ing
            elsif ing.check(preference) == "false"
              preference[1] << ing
            else
              preference[2] << ing
            end
          else
            preference[2] << ingredient
          end
        end
      end
    end
  end

  def classify_categories
    if current_user.preferences.nil?
      if !@false_vegan_flags.nil?
        @food.vegan = "false"
      elsif !@can_be_vegan_flags.nil? && @non_vegan_flags.nil?
        @food.vegan = "can-be"
      else
        @food.vegan = "true"
      end
    else
      @preferences.each do |preference|
        if !preference[1].nil?
          @food.update_flag(preference, "false")
        elsif !preference[2].nil? && preference[1].nil?
          @food.update_flag(preference, "can-be")
        else
          @food.update_flag(preference, "true")
        end
      end
    end
  end
end
