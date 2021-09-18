class TicketsController < ApplicationController
  before_action :set_event
  before_action :authenticate_user!

  def index
    
  end

  def create
    @ticket = current_user.tickets.create(event_id: params[:event_id])
  end

  def destroy
    @ticket = current_user.tickets.find_by(event_id: params[:event_id])
    @ticket.destroy
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
