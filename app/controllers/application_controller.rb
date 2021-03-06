class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?


  def counts(user)
    @count_followings = user.followings.count
    @count_followers = user.followers.count
  end

  def after_sign_in_path_for(resource)
    user_path(resource)
  end 

  protected

  def configure_permitted_parameters
    added_attrs = [ :email, :name, :password, :password_confirmation ,:profile, ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
end
