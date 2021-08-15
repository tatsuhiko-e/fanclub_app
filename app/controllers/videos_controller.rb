class VideosController < ApplicationController
  before_action :set_user, only: [:index, :show, :new, :destroy, :edit, :update]
  before_action :set_video, only: [:show, :destroy, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

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
      redirect_to action: :index
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
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    redirect_to action: :index
  end


  private

  def video_params
    params.require(:video).permit(:title, :youtube_url)
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def set_video
    @video = @user.videos.find(params[:id])
  end

  def ensure_correct_user
    if @video.user_id != current_user.id
      redirect_to root_path
    end
  end
end
