class AdminPanelController < ApplicationController

  before_action :check_login_status,except:[:login,:attempt_login]
  layout "admin_panel"

  def index
    @parking = ParkingAdmin.find(session[:admin_id]).parking
    @tickets = @parking.tickets.where("status>0 and status <3").paginate(:page=>params[:page],:per_page=>8)
  end
  def login
    if session[:admin_id]
      flash[:notice] = "You already logged in."
      redirect_to admin_panel_index_path
    end
  end

  def attempt_login
    parking_admin = ParkingAdmin.find_by_user_name(params[:username])
    if parking_admin
      if parking_admin.authenticate(params[:password])
        session[:admin_id] = parking_admin.id
        flash[:alert] = "Logged in successfully."
        redirect_to admin_panel_index_path
      else
        flash[:error] = "Username or password is wrong."
        redirect_to admin_panel_login_path
      end
    else
      flash[:error] = "Username or password is wrong."
      redirect_to admin_panel_login_path
    end
  end

  def logout
    if session[:admin_id].nil?
      flash[:error] = "You are not logged in."
      redirect_to admin_panel_login_path
    else
      session[:admin_id] = nil
      flash[:alert] = "You are successfully logged out."
      redirect_to admin_panel_login_path
    end
  end

  def checkin
    @token = params[:token]
  end

  def do_checkin
    if(ticket = Ticket.find_by_token(params[:token]))
      parking_id = ParkingAdmin.find(session[:admin_id]).parking.id
      if ticket.checkin!(params[:license],parking_id)
        flash[:alert] = "Ticket successfully checked in."
        redirect_to admin_panel_index_path
      else
        flash[:m_errors] = ticket.errors.full_messages
        redirect_to admin_panel_index_path
      end
    else
      flash[:error] = "Sorry ticket not found"
      redirect_to admin_panel_checkin_path,token: params[:token]
    end
  end

  def checkout
    @token = params[:token]
  end

  def do_checkout
    parking = ParkingAdmin.find(session[:admin_id]).parking
    if(@ticket = Ticket.find_by_token(params[:token]))
      if(@extra_time = @ticket.extra_hours_cal)
        if @ticket.vehicle_type =='car'
          @extra_amount = @extra_time * parking.car_price
        else
          @extra_amount = @extra_time * parking.bike_price
        end
      else
        @extra_amount = Money.new(0)
      end
      else
        flash[:error] = "Sorry ticket not found"
        redirect_to admin_panel_checkin_path,token: params[:token]
    end
  end

  def checkout_extra_amount
    parking = ParkingAdmin.find(session[:admin_id]).parking
    if(@ticket = Ticket.find_by_token(params[:token]))
      if(@extra_time = @ticket.extra_hours_cal)
        if @ticket.vehicle_type =='car'
          @extra_amount = @extra_time * parking.car_price
        else
          @extra_amount = @extra_time * parking.bike_price
        end
      else
        @extra_amount = Money.new(0)
      end
      @ticket.offline_amount = @ticket.offline_amount + @extra_amount
      if @ticket.checkout!(params[:token],parking.id)
        if @ticket.vehicle_type == 'car'
          parking.aval_car_spots = parking.aval_car_spots + 1
          parking.save
        else
          parking.aval_bike_spots = parking.aval_bike_spots + 1
          parking.save
        end
        flash[:alert] = "Successfully checked out."
        redirect_to admin_panel_index_path
      else
        flash[:m_errors] = @ticket.errors.full_messages
        redirect_to admin_panel_checkout_path,token: params[:token]
      end
    else
      flash[:error] = "Sorry ticket not found"
      redirect_to admin_panel_checkin_path,token: params[:token]
    end
  end

  def ticket
    @parking = ParkingAdmin.find(session[:admin_id]).parking
    if((@parking.aval_bike_spots==0) and (@parking.aval_car_spots==0))
      flash[:error] = "Sorry parking is full."
      redirect_to admin_panel_index_path
    end
  end

  def book_ticket
    parking = ParkingAdmin.find(session[:admin_id]).parking
    if params[:vehicle_type] == 'car'
      amount = parking.car_price
    else
      amount = parking.bike_price
    end
    book_ticket_params = {
      first_name:params[:first_name],
      last_name:params[:last_name],
      phone_number:params[:phone_number],
      vehicle_type:params[:vehicle_type],
      license:params[:license],
      status: 0,
      booked_hours:params[:booked_hours],
      checkin_time: Time.current.change(min:0,sec:0),
      parking_id: parking.id,
      offline_amount:amount*params[:booked_hours].to_i,
      online_amount: 0
    }
    book_ticket_params[:total_amount] = book_ticket_params[:offline_amount] + book_ticket_params[:online_amount]
    @ticket = Ticket.new(book_ticket_params)
    if @ticket.save
      session[:ticket_id] = @ticket.id
      session[:checkout_time] = @ticket.checkin_time + @ticket.booked_hours.hours
    else
      flash[:m_errors] = @ticket.errors.full_messages
      redirect_to admin_panel_ticket_path
    end
  end

  def complete_ticket_payment
    ticket = Ticket.find_by_token(params[:token])
    parking = ParkingAdmin.find(session[:admin_id]).parking
    if ticket
      ticket.status = 1
      ticket.save
      if ticket.checkin!(params[:license],parking.id)
        flash[:alert] = "Successfully booked."
        redirect_to admin_panel_index_path
      else
        flash[:m_errors] = ticket.errors.full_messages
        redirect_to admin_panel_index_path
      end
    else
      flash[:error] = "Ticket not found."
      redirect_to admin_panel_index_path
    end
  end
  private

  def check_login_status
    if session[:admin_id].nil?
      flash[:error] = "Please Login."
      redirect_to admin_panel_login_path
    end
  end
end
