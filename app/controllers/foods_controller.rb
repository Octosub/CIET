class FoodsController < ApplicationController
  require "google/cloud/translate"

  gtranslate_client = Google::Cloud::Translate.translation_v2_service( credentials: "grounded-elf-415603-0893a7160822.json")

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
