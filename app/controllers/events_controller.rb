class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_event, only: [:show, :destroy, :edit, :update, :ticket_users]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :redirect_to_root, only: [:new]

  def index

  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      flash[:success] = 'イベントを投稿しました。'
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_user_path(@event.user_id)
  end

  def ticket_users
    @users = @event.ticketed_users.all
  end

  private

  def event_params
    params.require(:event).permit(:title, :body, :place, :start_time, :event, :image)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def ensure_correct_user
    if @event.user_id != current_user.id
      redirect_to user_path(current_user)
    end
  end

  def redirect_to_root
    redirect_to user_path(current_user) if current_user.admin == false
  end
end
