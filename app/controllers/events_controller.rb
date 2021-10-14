class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :redirect_to_root, only: [:new]
  before_action :set_event, only: [:show, :destroy, :edit, :update, :ticket_users]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    @event_search = Event.ransack(params[:q])
    params[:q] = {"user_gender_eq_any"=>["0", "1", "2"]} if params[:q].nil?
    @results = @event_search.result.page(params[:page]).per(6)
    result_events = @results.where("start_time > ?",Date.today)
    @order_event = result_events.order(start_time: :desc)
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
      render "new"
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

  def day
    @events = Event.where("DATE(start_time) == '#{params[:id].to_date}'").page(params[:page]).per(6)
    @event_search = @events.ransack(params[:q])
    @results = @event_search.result.page(params[:page]).per(6)
    result_events = @results.where("start_time > ?",Date.today)
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
