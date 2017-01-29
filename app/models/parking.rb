class Parking < ApplicationRecord

  attr_accessor :distance_from_user
  belongs_to :city
  monetize :car_price_paisas
  monetize :bike_price_paisas

  validates :name, presence: true
  validates :address, presence: true
  validates :total_car_spots, numericality: { greater_than: 0 }
  validates :total_bike_spots, numericality: { greater_than: 0 }
  validates :longitude, presence: true
  validates :latitude, presence: true

  before_create :auto_generate_aval_car_bike_spots


  private
  def auto_generate_aval_car_bike_spots
    self.aval_car_spots = self.total_car_spots
    self.aval_bike_spots = self.total_bike_spots
  end
end
