class FoodsController < ApplicationController

  def show
    @food = Food.find(params[:id])
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    @food.user = current_user
    if @food.save
      redirect_to food_path(@food)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, photos: [])
  end
end
