class HomeController < ApplicationController
  def about
    admin_users = User.where(admin: true)
    @users = admin_users.where.not(theme: 0).order(created_at: :desc).limit(4)

    if user_signed_in?
      area_user1 = User.where(area: current_user.area, admin: true)
      @area_user = area_user1.where.not(theme: 0).order(created_at: :desc).limit(4)
    end
  end

  def makefanclub
  end
end
