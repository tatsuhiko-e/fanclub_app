class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit]
  before_action :ensure_correct_user, only: [:destroy]
  

  def index
    @users = User.where(admin: true)
    @user_search = @users.ransack(params[:q])
    @user_results = @user_search.result.page(params[:page])
  end

  def show
    @events = @user.events.order(start_time: :desc).limit(2)
    @posts = @user.posts.order(created_at: :desc).limit(2)
    
    
    # DM
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
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
