class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])

    # For additional in app/views/devise/registrations/edit.html.erb
    params[:user][:preferences] = params[:user][:preferences].join(" ") if params.dig(:user, :preferences)
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :preferences, :photo])
  end

end
