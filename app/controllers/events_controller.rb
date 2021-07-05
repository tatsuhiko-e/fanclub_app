class EventsController < ApplicationController
    before_action :set_event, only: [:destroy, :edit, :update]
    before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  
    def index
      @user = User.find_by(id: params[:user_id])
      @events = @user.posts.where(event: true)
    end
  
    def show
      @user = User.find_by(id: params[:user_id])
      @event = @user.events.find(params[:id])
    end
  
    def new
      @user = User.find_by(id: params[:user_id])
      @event = Event.new
    end
  
    def create
      @event = Event.new(event_params)
      @event.user_id = current_user.id
      if @event.save
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
      if @event.update(event_params)
        redirect_to action: :index
      else
        render :edit
      end
    end
  
    def destroy
      @event.destroy
      redirect_to action: :index
    end
  
    private
  
    def event_params
      params.require(:event).permit(:title, :body, :start_time)
    end
  
    def set_event
      @event = Event.find(params[:id])
    end
  
    def ensure_correct_user
      if @event.user_id != current_user.id
        redirect_to root_path
      end
    end
end
