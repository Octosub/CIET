class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @food = Food.new
  end

  # def changepreferences
  # end

  # def updatepreferences
  #   if current_user.update(user_params)
  #     redirect_to root_path
  #   else
  #     render 'changepreferences'
  #   end
  # end

  # private

  # def user_params
  #   params[:changepreferences][:preferences] = params[:changepreferences][:preferences].join(" ")
  #   params.require(:changepreferences).permit(:preferences)
  # end
end
