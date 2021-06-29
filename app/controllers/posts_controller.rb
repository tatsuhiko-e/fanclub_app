class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @user = User.find_by(id: params[:user_id])
    unless @user.admin?
      redirect_to @user
    end
  end

  def show
    @user = User.find_by(id: params[:user_id])
  end

  def new
    @user = User.find_by(id: params[:user_id])
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(id: params[:user_id])
  end

  def update
    @user = User.find_by(id: params[:user_id])
    if @post.update(post_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to action: :index
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :start_time)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    if @post.user_id != current_user.id
      redirect_to root_path
    end
  end
end
