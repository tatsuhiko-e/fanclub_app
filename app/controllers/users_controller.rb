class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit]
  before_action :ensure_correct_user, only: [:update, :destroy]
  

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

  def ensure_correct_user
    if @user_id != current_user.id
      redirect_to root_path
    end
  end
end
