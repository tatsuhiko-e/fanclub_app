class EventsController < ApplicationController
  before_action :set_user, only: [:index, :show, :new, :edit, :update]
  before_action :set_event, only: [:destroy, :edit, :update, :ticket_users]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @events = @user.events.order(start_time: :desc)
  end

  def show
    @event = @user.events.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      flash[:success] = 'イベントを投稿しました。'
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
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

  def ticket_users
    @users = @event.ticketed_users.all
  end

  private
  def set_user
    @user = User.find_by(id: params[:user_id])
  end


  def event_params
    params.require(:event).permit(:title, :body, :place, :start_time, :event, :image)
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
