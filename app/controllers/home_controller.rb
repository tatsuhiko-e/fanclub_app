class HomeController < ApplicationController
  def about
    @users = User.where(admin: true).order(created_at: :desc).limit(3)
    if user_signed_in?
      @area_user = User.where(area: current_user.area, admin: true)
    end
  end

end
