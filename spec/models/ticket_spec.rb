require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it "should monetize online_amount" do
    is_expected.to monetize(:online_amount)
  end

  it "should monetize offline_amount" do
    is_expected.to monetize(:offline_amount)
  end
  it "should monetize total_amount" do
    is_expected.to monetize(:total_amount)
  end
  it "should have association with parking model" do
    ticket = build(:ticket,parking_id: nil)
    expect(ticket).to_not be_valid
  end

  it "should return parking object on .parking call" do
    parking = create(:parking)
    ticket  = build(:ticket,parking_id: parking.id)
    expect(ticket.parking).to eq(parking)
  end

  it "should not valid if license is empty string" do
    ticket = build(:ticket,license: ' ')
    expect(ticket).to_not be_valid
  end

  it "should not validate if license is nil" do
    ticket = build(:ticket,license: nil)
    expect(ticket).to_not be_valid
  end

  it "should not valid if first_name is empty string" do
    ticket = build(:ticket,first_name: ' ')
    expect(ticket).to_not be_valid
  end

  it "should not valid if first_name is nil" do
    ticket = build(:ticket,first_name: nil)
    expect(ticket).to_not be_valid
  end

  it "should not valid if last_name is empty string" do
    ticket = build(:ticket,last_name: ' ')
    expect(ticket).to_not be_valid
  end

  it "should not valid if last_name is nil" do
    ticket = build(:ticket,last_name: nil)
    expect(ticket).to_not be_valid
  end

  it "should not valid if phone_number is empty string" do
    ticket = build(:ticket,phone_number: ' ')
    expect(ticket).to_not be_valid
  end

  it "should not valid if phone_number is nil" do
    ticket = build(:ticket,phone_number: nil)
    expect(ticket).to_not be_valid
  end

  it "should valid if phone_number string is less than 10" do
    ticket = build(:ticket,phone_number:'111111111')
    expect(ticket).to_not be_valid
  end
  it "should not valid if phone_number string is more than 10" do
    ticket = build(:ticket,phone_number:'12345678901')
    expect(ticket).to_not be_valid
  end
  it "should valid if phone_number string is equal to 10" do
    ticket = build(:ticket)
    expect(ticket).to be_valid
  end

  it "should not valid if vehicle type is other than car and bike" do
    ticket = build(:ticket,vehicle_type:'carbike')
    expect(ticket).to_not be_valid
  end
  it "should valid if vehicle_type is car" do
    ticket = build(:ticket,vehicle_type:'car')
    expect(ticket).to be_valid
  end
  it "should valid if vehicle_type is bike" do
    ticket = build(:ticket,vehicle_type:'bike')
    expect(ticket).to be_valid
  end
  it "should not valid if vehicle_type is in Upcase" do
    ticket = build(:ticket,vehicle_type:'bike'.upcase!)
    expect(ticket).to_not be_valid
  end
  it "should not valid if vehicle_type is capitalize" do
    ticket = build(:ticket,vehicle_type:'bike'.capitalize)
    expect(ticket).to_not be_valid
  end

  it "should not valid if checkin_time is not present" do
    ticket = build(:ticket,checkin_time:nil)
    expect(ticket).to_not be_valid
  end

  it "should not valid if booked hours is nil" do
    ticket = build(:ticket,booked_hours: nil)
    expect(ticket).to_not be_valid
  end

  it "should not valid if booked hours are less than 4" do
    ticket = build(:ticket,booked_hours: 3)
    expect(ticket).to_not be_valid
  end

  it "should not valid if booked hours are more than 24" do
    ticket = build(:ticket,booked_hours: 25)
    expect(ticket).to_not be_valid
  end

  it "should valid if booked hours are within range(4 to 24)" do
    ticket = build(:ticket,booked_hours:20)
    expect(ticket).to be_valid
  end

  it "should not valid if status is nil" do
    ticket = build(:ticket,status: nil)
    expect(ticket).to_not be_valid
  end

  it "should not valid if status is less than zero" do
    ticket = build(:ticket,status: -1)
    expect(ticket).to_not be_valid
  end

  it "should not valid is status is greater than 3" do
    ticket = build(:ticket,status: 4)
    expect(ticket).to_not be_valid
  end

  it "should not valid if status is empty string" do
    ticket = build(:ticket,status: ' ')
    expect(ticket).to_not be_valid
  end

  it "should generate token after create and then save again" do
    ticket = create(:ticket)
    expect(ticket.token).to_not eq(nil)
  end

  it "should not valid if token is not present on update" do
    ticket = create(:ticket)
    ticket.token = nil
    expect(ticket).to_not be_valid
  end

  it "should not update valid token is empty string on update" do
    ticket = create(:ticket)
    ticket.token = ' '
    expect(ticket).to_not be_valid
  end

  it "should decrement parking aval_car_spots on ticket(vehicle_type car) creation" do
    parking = create(:parking)
    ticket = create(:ticket,vehicle_type:'car', parking_id:parking.id)
    expect(Parking.find(parking.id).aval_car_spots).to eq(parking.aval_car_spots-1)
  end

  it "should decrement parking aval_car_spots on ticket(vehicle_type bike) creation" do
    parking = create(:parking)
    ticket = create(:ticket,vehicle_type:'bike', parking_id:parking.id)
    expect(Parking.find(parking.id).aval_bike_spots).to eq(parking.aval_bike_spots-1)
  end

  it "should not book ticket if aval_car_spots is zero" do
    parking = create(:parking)
    parking.aval_bike_spots = 0
    parking.save
    ticket = build(:ticket,vehicle_type:'bike', parking_id:parking.id)
    expect(ticket.save).to eq false
    expect(Parking.find(parking.id).aval_bike_spots).to eq(parking.aval_bike_spots)
  end

  it "should not book ticket if aval_bike_spots is zero" do
    parking = create(:parking)
    parking.aval_car_spots = 0
    parking.save
    ticket = build(:ticket,vehicle_type:'car', parking_id:parking.id)
    expect(ticket.save).to eq false
    expect(ticket.errors.full_messages).to eq(["Sorry can't book ticket parking is full."])
    expect(Parking.find(parking.id).aval_car_spots).to eq(parking.aval_car_spots)
  end

  it "should not fire before_create callback on ticket update" do
    parking = create(:parking)
    expect(Ticket.count).to eq(0)
    ticket = create(:ticket,vehicle_type:'car', parking_id:parking.id)
    expect(Parking.find(parking.id).aval_car_spots).to eq(parking.aval_car_spots-1)
    ticket.token = "HKJHKK"
    ticket.save
    expect(Ticket.count).to eq(1)
    expect(Parking.find(parking.id).aval_car_spots).to eq(parking.aval_car_spots-1)
  end

  it "should checkin ticket" do
    parking = create(:parking)
    ticket = create(:ticket,parking_id: parking.id,status:1,checkin_time: Time.now.change(min:0,sec:0))
    ticket.checkin!(ticket.license,parking.id)
    expect(ticket.status).to eq(2)
  end

  it "should return false on checking! method call if ticket comes before checkin time" do
    parking = create(:parking)
    ticket = create(:ticket,parking_id: parking.id,status:1,checkin_time: Time.now.change(min:0,sec:0)+1.hours)
    expect(ticket.checkin!(ticket.license,parking.id)).to eq(false)
    expect(ticket.status).to eq(1)
    expect(ticket.errors.full_messages.any?{ |error| "Can't checkin before expected checkin time" }).to eq true
  end

  it "should return false on checking! method call if ticket is not paid" do
    parking = create(:parking)
    ticket = create(:ticket,parking_id: parking.id,checkin_time: Time.now.change(min:0,sec:0)+1.hours)
    expect(ticket.checkin!(ticket.license,parking.id)).to eq(false)
    expect(ticket.status).to eq(0)
    expect(ticket.errors.full_messages.any? { |error| "Ticket is not paid." }).to eq true
  end

  it "should return false on checking! method call if ticket comes after the booking period" do
    parking = create(:parking)
    ticket = create(:ticket,parking_id: parking.id,booked_hours:4,status:1,checkin_time: Time.now.change(min:0,sec:0)-5.hours)
    expect(ticket.checkin!(ticket.license,parking.id)).to eq(false)
    expect(ticket.status).to eq(1)
    expect(ticket.errors.full_messages.any? { |error| "Sorry Ticket expired" }).to eq true
  end

  it "should return false on checking! method call if ticket is already used(i.e. status:3)" do
    parking = create(:parking)
    ticket = create(:ticket,parking_id: parking.id,booked_hours:4,status:3,checkin_time: Time.now.change(min:0,sec:0))
    expect(ticket.checkin!(ticket.license,parking.id)).to eq(false)
    expect(ticket.status).to eq(3)
    expect(ticket.errors.full_messages.any? { |error| "Ticket is already used." }).to eq true
  end

  it "should return false on checking! method call if given license number not matched with ticket.license number" do
    parking = create(:parking)
    ticket = create(:ticket,parking_id: parking.id,booked_hours:4,status:1,checkin_time: Time.now.change(min:0,sec:0))
    expect(ticket.checkin!("FOOL",parking.id)).to eq(false)
    expect(ticket.status).to eq(1)
    expect(ticket.errors.full_messages.any? { |error| "Sorry License plate number is wrong." }).to eq true
  end

  it "should return false on checking! method call if another parking's ticket trying to checking" do
    parking1 = create(:parking)
    city2 = create(:city,name:'city2',code:'CODE2')
    parking2 = create(:parking,city_id:city2.id)
    ticket = create(:ticket,parking_id: parking1.id,booked_hours:4,status:1,checkin_time: Time.now.change(min:0,sec:0))
    expect(ticket.checkin!(ticket.license,parking2.id)).to eq(false)
    expect(ticket.status).to eq(1)
    expect(ticket.errors.full_messages.any?{ |error| "Ticket is not for this parking" }).to eq true
  end

  it "should upadate ticket data in database after checkin! method call" do
    parking = create(:parking)
    expect(Ticket.count).to eq(0)
    ticket = create(:ticket,parking_id: parking.id,booked_hours:4,status:1,checkin_time: Time.now.change(min:0,sec:0))
    expect(Ticket.count).to eq(1)
    ticket.checkin!(ticket.license,ticket.parking_id)
    expect(Ticket.find(ticket.id).status).to eq(2)
  end

  it "should checkout ticket if ticket is provided with correct parameter" do
    parking = create(:parking)
    ticket = create(:ticket,status:2,parking_id:parking.id)
    expect(ticket.checkout!(ticket.license,parking.id)).to eq true
    expect(ticket.status).to eq(3)
  end

  it "checkout! method should return  false is ticket is checked in" do
    parking = create(:parking)
    ticket = create(:ticket,status:1,parking_id:parking.id)
    expect(ticket.checkout!(ticket.license,parking.id)).to eq false
    expect(ticket.errors.full_messages.any? { |error| "Can't checkout ticket is not checked in yet." }).to eq true
    expect(ticket.status).to eq(1)
  end

  it "checkout! method should return false id ticket is not paid." do
    parking = create(:parking)
    ticket = create(:ticket,parking_id:parking.id)
    expect(ticket.checkout!(ticket.license,parking.id)).to eq false
    expect(ticket.errors.full_messages.any? { |error| "Ticket is not paid." }).to eq true
    expect(ticket.status).to eq(0)
  end
  it "checkout! method should return false id ticket's license and given license not match" do
    parking = create(:parking)
    ticket = create(:ticket,status:1,parking_id:parking.id)
    expect(ticket.checkout!("BLAHBLAH",parking.id)).to eq false
    expect(ticket.errors.full_messages.any? { |error| "Sorry License plate number is wrong." }).to eq true
    expect(ticket.status).to eq(1)
  end

  it "checkout! should return false if ticket is for another parking" do
    parking = create(:parking)
    ticket = create(:ticket,status:1,parking_id:parking.id)
    expect(ticket.checkout!(ticket.license,2)).to eq false
    expect(ticket.errors.full_messages.any?{ |error| "Ticket is not for this parking"}).to eq true
    expect(ticket.status).to eq(1)
  end

  it "extra_hours_cal method should return false if ticket booked hours time is in range" do
    parking = create(:parking)
    ticket = create(:ticket,status:1,parking_id:parking.id,checkin_time: Time.now.change(min:0,sec:0)-2.hours,booked_hours:4)
    expect(ticket.extra_hours_cal).to eq false
  end

  it "extra_hours_cal method should return noumer of hours if ticket stays more than booked time" do
    parking = create(:parking)
    ticket = create(:ticket,status:1,parking_id:parking.id,checkin_time: Time.now.change(min:0,sec:0)-29.hours,booked_hours:4)
    expect(ticket.extra_hours_cal).to eq 25
  end
end
