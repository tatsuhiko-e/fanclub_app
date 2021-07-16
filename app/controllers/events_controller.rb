class EventsController < ApplicationController
    def index
      
    end
  
    def show
      @user = User.find_by(id: params[:user_id])
      @event = @user.posts.find(params[:id])
    end
end
