class PostsController < ApplicationController
  before_action :set_user, only: [:index, :show, :new, :destroy, :edit, :update]
  before_action :set_post, only: [:show, :destroy, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @user = User.find_by(id: params[:user_id])
    unless @user.admin?
      redirect_to @user
    end
  end

  def show
    
  end

  def new
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
  end

  def update
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

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :event, :image, :start_time)
  end

  def set_post
    @post = @user.posts.find(params[:id])
  end

  def ensure_correct_user
    if @post.user_id != current_user.id
      redirect_to root_path
    end
  end
end
