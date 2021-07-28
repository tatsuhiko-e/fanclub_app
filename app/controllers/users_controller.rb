class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit]
  before_action :ensure_correct_user, only: [:destroy]
  

  def index
    @user_search = User.ransack(params[:q])
    @user_results = @user_search.result.page(params[:page])
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

  def likelist
    @posts = current_user.like_posts
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
