class UsersController < ApplicationController
  def update
    @user = User.find(params[:id])
    # raise
    # user_params
    # if @user.preferences = params[:preferences]
    if @user.update(user_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  private

  # def user_params
  #   preferences = params[:preferences].join(", ")
  #   params.require(:user).permit(:preferences).merge(preferences: preferences)
  #   raise
  # end
  def user_params
    params[:user][:preferences] = params[:user][:preferences].join(" ")
    params.require(:user).permit(:preferences)
  end
end
