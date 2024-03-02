class FoodsController < ApplicationController

  require 'json'
  require "open-uri"
  require "i18n"

  def index
    @foods = current_user.foods.reverse_order
  end

  def show
    @food = Food.find(params[:id])
    # @non_vegan_flags = @food.non_vegan_flags
    vegan_classification
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    @food.user = current_user

    if @food.save
      @food.extract_ingredients
      @food.translate
      @food.vegan = @food.vegan_boolean
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
      @food.name = food_params[:name]
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


  def vegan_classification
    ingredients = vegan_api
    if @food.ingredient_list.split(',').length > 1
      @non_vegan_flags = ingredients["isVeganResult"]["nonvegan"]
    else
      @non_vegan_flags = []
    end
    @
  end

  def vegan_api
    ingredients = @food.ingredient_list.gsub("&#39;", "")
    url = "https://is-vegan.netlify.app/.netlify/functions/api?ingredients=#{I18n.transliterate(ingredients)}"
    ingredients_serialized = HTTParty.get(url).body
    JSON.parse(ingredients_serialized)
  end
end
