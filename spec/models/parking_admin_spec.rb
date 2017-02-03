require 'rails_helper'

RSpec.describe ParkingAdmin, type: :model do
  it "should create parking admin" do
    expect(ParkingAdmin.count).to eq(0)
    create(:parking_admin)
    expect(ParkingAdmin.count).to eq(1)
  end

  it "should not valid if first_name is empty string" do
    parking_admin = build(:parking_admin,first_name:' ')
    expect(parking_admin).to_not be_valid
  end

  it "should not valid if last_name is empty string" do
    parking_admin = build(:parking_admin,last_name:' ')
    expect(parking_admin).to_not be_valid
  end

  it "should not valid if user_name is empty string" do
    parking_admin = build(:parking_admin,user_name:' ')
    expect(parking_admin).to_not be_valid
  end

  it "should not valid if user_name is not unique" do
    create(:parking_admin)
    city = create(:city,name:'zbc',code:'cvf')
    parking = create(:parking,city_id:city.id)
    parking_admin = build(:parking_admin,parking_id:parking.id)
    expect(parking_admin).to_not be_valid
  end

  it "should not valid if password is nil" do
    parking_admin = build(:parking_admin,password:nil)
    expect(parking_admin).to_not be_valid
  end

  it "should not valid if password is  string" do
    parking_admin = build(:parking_admin,password:'  ')
    expect(parking_admin).to_not be_valid
  end

  it "should not valid if password length is less than 6" do
    parking_admin = build(:parking_admin,password:'12345')
    expect(parking_admin).to_not be_valid
  end

  it "should not valid if password length is more than 20" do
    parking_admin = build(:parking_admin,password:'1234567890098765432211')
    expect(parking_admin).to_not be_valid
  end


  it "should return parking model object on calling #parking method" do
    parking_admin = create(:parking_admin)
    expect(parking_admin.parking).to be_a Parking
  end

end
