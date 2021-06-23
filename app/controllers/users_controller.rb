class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit]

  def index
    if params[:approved] == "false"
      @users = User.where(approved: false)
    else
      @users = User.all
    end
  end

  def show
    
  end

  def edit
    unless @user == current_user
    redirect_to user_path(current_user.id)
    end
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user.id)
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
