class TicketsController < ApplicationController
  before_action :authenticate_user!
  def payment
    if session[:ticket_id]
      @ticket = Ticket.find(session[:ticket_id])
      #@ticket.status = 1
      #@ticket.save
      #flash[:alert] = "Ticket is Successfully booked."
      #redirect_to parkings_path(@ticket.parking.city.name)
    else
      flash[:error] = "Something went wrong."
      redirect_to root_path
    end
  end

  def payment_complete
    if(params[:name].present? and params[:card].present? and
       params[:expiry_y].present? and
        params[:expiry_m].present? and params[:cvv].present?)
      @ticket = Ticket.find(session[:ticket_id])
      @ticket.status = 1
      @ticket.save
      ActionCable.server.broadcast 'notify_booking',@ticket
      session[:ticket_id] = nil
      flash[:alert] = "Ticket is Successfully booked"
      redirect_to parkings_path(@ticket.parking.city.name)
    else
      flash[:error] = "Please enter correct information."
      redirect_to tickets_payment_path
    end
  end
end
