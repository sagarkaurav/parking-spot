class ParkingsController < ApplicationController
  def index
    if(City.find_by_name(params[:city_name].downcase))
      @parkings = City.find_by_name(params[:city_name]).parkings.paginate(:page=>params[:page],:per_page=>3)
       @parkings.map do |parking|
       if (session[:latitude] > 0 && session[:longitude] > 0) and !(session[:latitude].nil? && session[:longitude].nil?)
         parking.distance_from_user = Geocoder::Calculations.distance_between([session[:latitude],session[:longitude]],[parking.latitude,parking.longitude],:units=>:km).round(2)
       else
         parking.distance_from_user = 'Unknown'
       end
     end
    else
      flash[:error] = "Parking not found."
      redirect_to root_path
    end
  end

  def book

    if(Parking.where('id = ?',params[:parking_id]))
      @parking = Parking.find(params[:parking_id])
      session[:parking_id] = @parking.id
      if((@parking.aval_car_spots > 0) or (@parking.aval_bike_spots > 0 ))
      else
        flash[:error] = "Parking is already full."
        redirect_to parkings_path(@parking.city.name)
      end
    else
      flash[:error] = "Sorry parking not found"
      redirect_to root_path
    end

  end

  def ticket
    parking = Parking.find(session[:parking_id])
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
      checkin_time: Time.current.change({hour:params[:checkin_time].to_i}),
      parking_id: session[:parking_id],
      offline_amount: 0,
      online_amount: amount*params[:booked_hours].to_i
    }
    book_ticket_params[:total_amount] = book_ticket_params[:offline_amount] + book_ticket_params[:online_amount]
    @ticket = Ticket.new(book_ticket_params)
    if @ticket.save
      session[:ticket_id] = @ticket.id
      session[:checkout_time] = @ticket.checkin_time + @ticket.booked_hours.hours
    else
      flash[:m_errors] = @ticket.errors.full_messages
      redirect_to parkings_book_path(session[:parking_id])
    end
  end
end
