class TicketsController < ApplicationController

  def index
    
  end

  def create
    @ticket = current_user.tickets.create(event_id: params[:event_id])
  end

  def destroy
    @ticket = current_user.tickets.find_by(event_id: params[:event_id])
    @ticket.destroy
  end
end
