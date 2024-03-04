class FoodsController < ApplicationController

  require 'json'
  require "open-uri"
  require "i18n"

  def index
    @foods = current_user.foods.reverse_order
  end

  def show
    @food = Food.find(params[:id])
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
    vegan_api_call = @food.vegan_api
    if @food.ingredient_list.split(',').length > 1
      @non_vegan_flags = vegan_api_call["isVeganResult"]["nonvegan"]
    else
      @non_vegan_flags = []
    end
    @true_vegan_flags = @food.ingredient_list.split(',') - @non_vegan_flags
    # @can_be_vegan_flags = @food.ingredient_list.split(',') - @true_vegan_flags - @non_vegan_flags
  end
end
