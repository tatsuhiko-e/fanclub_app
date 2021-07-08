class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def create
    
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = params[:post_id]
    if @comment.save
      redirect_to post_url(params[:post_id])
    else
      @post = Post.find(params[:post_id])
      render "posts/show"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @post = Post.find(params[:post_id])
    redirect_to @post
  end
  
  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def ensure_correct_user
    @comment = Comment.find(params[:id])
    if @comment.user_id != current_user.id
      redirect_to root_path
    end
  end
end
