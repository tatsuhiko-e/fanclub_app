class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :show, :create, :edit, :update, :destroy]
  before_action :set_video, only: [:show, :destroy, :edit, :update]
  before_action :redirect_to_root, only: [:new]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  
  
  def index
  end

  def show
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    @video.user_id = current_user.id
    url = params[:video][:youtube_url]
    url = url.last(11)
    @video.youtube_url = url
    if @video.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to video_path(@video)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @video.update(video_params)
      
      url = params[:video][:youtube_url]
      url = url.last(11)
      @video.youtube_url = url
      redirect_to video_path(@video)
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    redirect_to videos_user_path(@video.user_id)
  end


  private

  def video_params
    params.require(:video).permit(:title, :youtube_url)
  end

  def set_video
    @video = Video.find(params[:id])
  end

  def ensure_correct_user
    if @video.user_id != current_user.id
      redirect_to user_path(current_user)
    end
  end

  def redirect_to_root
    redirect_to user_path(current_user) if current_user.admin == false
  end
end
