class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]

  def show
  end

  def edit
    unless @user == current_user
    redirect_to user_path(@user)
    end
  end

  def update
    if current_user.update(user_params)
      redirect_to (@user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile, :area, :gender, :age, :image)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
