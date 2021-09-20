class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy, :edit, :update]
  before_action :authenticate_user!, only: [:show, :new, :destroy, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :redirect_to_root, only: [:new]
  
  def index

  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      flash[:alert] = "投稿に失敗しました"
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_user_path(@post.user_id)
  end

  private

  def post_params
    params.require(:post).permit(:title, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_user
    if @post.user_id != current_user.id
      redirect_to root_path
    end
  end
  
  def redirect_to_root
    redirect_to user_path(current_user) if current_user.admin == false
  end
end
