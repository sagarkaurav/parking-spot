class Ticket < ApplicationRecord
  belongs_to :parking

  monetize :online_amount_paisas
  monetize :offline_amount_paisas
  monetize :total_amount_paisas

  validates :license, presence: true
  validates :token, presence: true, on: :update
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true
  validates :phone_number, length: {is:10}
  validates_inclusion_of :vehicle_type, :in => %w(car bike), :on => :create, :message => "The Vehicle Type is not allowed"
  validates :checkin_time, presence: true
  validates :booked_hours, presence: true
  validates :booked_hours, numericality: { only_integer: true,greater_than: 3,less_than: 25 }
  validates :status, numericality: { only_integer: true,greater_than_or_equal_to:0 ,less_than:4 }

  before_create :update_parking_aval_spots
  after_create :generate_token

  def checkin!(license,parking_id)
    expected_arrival_before = self.checkin_time+ self.booked_hours.hours
    if((self.status==1) and(self.license==license) and(Time.now.between?(self.checkin_time,expected_arrival_before)) and (self.parking_id==parking_id))
      self.status = 2
      self.total_amount = self.online_amount + self.offline_amount
      self.save
    elsif(self.status == 0)
      self.errors.add(:base,"Ticket is not paid.")
      return false
    elsif(self.status == 3)
      self.errors.add(:base,"Ticket is already used.")
      return false
    elsif(self.license != license)
       self.errors.add(:base,"Sorry License plate number is wrong.")
       return false
     elsif(Time.now < self.checkin_time)
       self.errors.add(:base,"Can't checkin before expected checkin time")
       return false
     elsif(Time.now > expected_arrival_before)
       self.errors.add(:base,"Sorry Ticket expired")
       return false
     elsif(self.parking_id != parking_id)
      self.errors.add(:base,"Ticket is not for this parking")
      return false
    end
  end

  def checkout!(license,parking_id)
    if(self.status == 2)
      self.status = 3
      self.checkout_time = Time.now
      self.total_amount = self.online_amount + self.offline_amount
      self.save
    elsif(self.status == 1)
      self.errors.add(:base,"Can't checkout ticket is not checked in yet.")
      return false
    elsif(self.status == 0)
      self.errors.add(:base,"Ticket is not paid.")
      return false
    elsif(self.status == 3)
      self.errors.add(:base,"Ticket is already used.")
      return false
    elsif(self.license != license)
      self.errors.add(:base,"Sorry License plate number is wrong.")
      return false
    elsif(self.parking_id != parking_id)
      self.errors.add(:base,"Ticket is not for this parking")
      return false
    end
  end

  def extra_hours_cal
    booked_time = (self.checkin_time + self.booked_hours.hours)
    time_now  = Time.now.change(min:0,sec:0)

    if (time_now.between?(self.checkin_time,booked_time) or(time_now == booked_time))
      return false
    else
      (((time_now-booked_time)/60)/60).to_i
    end
  end
  private

  def update_parking_aval_spots
    parking = Parking.find(self.parking_id)
    if ((self.vehicle_type == 'car') && (parking.aval_car_spots > 0))
      parking.aval_car_spots = parking.aval_car_spots-1
      parking.save
    elsif ((self.vehicle_type == 'bike') && (parking.aval_bike_spots > 0))
      parking.aval_bike_spots = parking.aval_bike_spots-1
      parking.save
    else
      self.errors.add(:base,"Sorry can't book ticket parking is full.")
      throw :abort
    end
  end

  def generate_token
      city_code = Parking.find(parking_id).city.code
      self.token = AlphaNumericToken::ANS.generate(city_code,4,self.id)
      save
  end

end
