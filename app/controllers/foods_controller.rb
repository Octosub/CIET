class FoodsController < ApplicationController

  require 'json'
  require "open-uri"

  def index
    @foods = current_user.foods
  end

  def show
    @food = Food.find(params[:id])
    @vegan_boolean = vegan_check
    @vegan_flags = vegan_flags
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
      @vegan_boolean = vegan_check
      @food.vegan = @vegan_boolean
      @food.save
      puts "save successfull!"
      redirect_to food_path(@food)
    else
      flash[:error] = @food.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def vegan_check
    ingredients = vegan_api
    ingredients["isVeganSafe"]
  end

  def vegan_flags
    ingredients = vegan_api
    if @food.ingredient_list.split(',').length > 1
      return ingredients["isVeganResult"]["nonvegan"]
    else
      return []
    end
  end

  def vegan_api
    url = "https://is-vegan.netlify.app/.netlify/functions/api?ingredients=#{@food.ingredient_list}"
    ingredients_serialized = URI.open(url).read
    JSON.parse(ingredients_serialized)
  end

  private

  def food_params
    params.require(:food).permit(:name, :ingredient_list, :vegan, photos: [])
  end
end
