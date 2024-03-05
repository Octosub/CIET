class FavoritesController < ApplicationController

  def create
    food = Food.find(params[:food_id])
    favorite = Favorite.new
    favorite.food = food
    favorite.user = current_user
    if favorite.save
      redirect_to foods_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to foods_path, status: :see_other
  end

end
