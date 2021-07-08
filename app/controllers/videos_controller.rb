class VideosController < ApplicationController
  before_action :set_user, only: [:index, :show, :new, :destroy, :edit, :update]

  def show
    @post = @user.videos.find(params[:id])
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

  private

  def video_params
    params.require(:video).permit(:title, :youtube_url)
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end
end