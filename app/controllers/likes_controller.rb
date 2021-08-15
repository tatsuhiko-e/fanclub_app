class LikesController < ApplicationController
  
  def create
      @like = current_user.likes.create(post_id: params[:post_id])
  end

  def destroy
      @like = current_user.likes.find_by(post_id: params[:post_id])
      @like.destroy
  end

  private

end
