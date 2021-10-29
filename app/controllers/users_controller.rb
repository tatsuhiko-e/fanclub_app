class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :posts, :events, :videos, :contacts]
  before_action :ensure_correct_user, only: [:destroy]

  def index
    @users = User.where(admin: true)
    @user_search = @users.ransack(params[:q])
    @user_results = @user_search.result.page(params[:page])
   
  end

  def show
    redirect_to root_path if !user_signed_in? && !@user.admin?
    redirect_to edit_user_path(@user) if !@user.image.attached?
    redirect_to edit_user_path(@user) if @user.admin? && @user.theme == 0
    @events = @user.events.order(start_time: :desc).limit(2)
    @posts = @user.posts.order(created_at: :desc).limit(2)
    
    
    # DM
    # if user_signed_in?
    #   @currentUserEntry=Entry.where(user_id: current_user.id)
    #   @userEntry=Entry.where(user_id: @user.id)
    #   if @user.id == current_user.id
    #   else
    #     @currentUserEntry.each do |cu|
    #       @userEntry.each do |u|
    #         if cu.room_id == u.room_id then
    #           @isRoom = true
    #           @roomId = cu.room_id
    #         end
    #       end
    #     end
    #     if @isRoom
    #     else
    #       @room = Room.new
    #       @entry = Entry.new
    #     end
    #   end
    # end
  end

  def edit   
    unless @user == current_user
      redirect_to user_path(current_user.id)
    end
  end

  def update
    if current_user.update(user_params)
      session[:crop_x] = user_params[:x]
      session[:crop_y] = user_params[:y]
      session[:crop_width] = user_params[:width]
      session[:crop_height] = user_params[:height]

      redirect_to user_path(current_user.id)
    else 
      render :edit
    end
  end

  def posts
    @search = @user.posts.ransack(params[:q])
    @results = @search.result.page(params[:page]).per(6)
  end

  def events
    @events = @user.events.order(start_time: :desc)
    @next_event = @user.events.find_by("start_time > ?",Date.today)
  end

  def videos
    @videos = @user.videos
  end

  def contacts
    @contact = Contact.new
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile, :area, :gender, :age, :theme, :image, :x, :y, :width, :height)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    if @user.id != current_user.id
      redirect_to root_path
    end
  end
end
