class CitiesController < ApplicationController
  def index
    cities = City.all
    @tags = ""
    cities.each do |city|
      @tags << city.name << ","
    end
  end

  def find
    city = City.find_by_name(params[:city].downcase)
    if(!params[:longitude].present? and !params[:latitude].present?)
      session[:longitude] = 0
      session[:latitude] = 0
    else
      session[:longitude] = params[:longitude].to_f
      session[:latitude] = params[:latitude].to_f
    end
    if city
      redirect_to parkings_path(city.name)
    else
      flash[:error] = "Sorry city is not available"
      redirect_to root_path
    end
  end
end
