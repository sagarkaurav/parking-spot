require 'rails_helper'

RSpec.describe Parking, type: :model do
  it "should monetize car_price atrribute" do
    is_expected.to monetize(:car_price)
  end
  it "should monetize bike_price attribute" do
    is_expected.to monetize(:bike_price)
  end

  it "should belongs to city model" do
    city = create(:city)
    parking = build(:parking,city_id: city.id)
    expect(parking.city).to eq(city)
  end

  it "should not valid if name is empty string" do
    parking = build(:parking,name: ' ')
    expect(parking).to_not be_valid
  end

  it "should not valid if name is nil" do
    parking = build(:parking,name: nil)
    expect(parking).to_not be_valid
  end

  it "should not valid if address is empty string" do
    parking = build(:parking,address: ' ')
    expect(parking).to_not be_valid
  end

  it "should not valid if address is nil" do
    parking = build(:parking,address: nil)
    expect(parking).to_not be_valid
  end

  it "should not valid if total_car_spots  is zero" do
    parking = build(:parking,total_car_spots: 0)
    expect(parking).to_not be_valid
  end

  it "should not valid if total_car_spots is less than zero" do
    parking = build(:parking,total_car_spots: -10)
    expect(parking).to_not be_valid
  end

  it "should not valid if total_bike_spots is zero" do
    parking = build(:parking,total_bike_spots: 0)
    expect(parking).to_not be_valid
  end

  it "should not valid if total_bike_spots is less than zero" do
    parking = build(:parking,total_bike_spots: -10)
    expect(parking).to_not be_valid
  end

  it "should autometically generate aval_car_spots on create if they are not given" do
    parking = create(:parking,aval_car_spots: nil)
    expect(parking.aval_car_spots).to eq(parking.total_car_spots)
  end

  it "should autometically generate aval_bike_spots on create if they are not given" do
    parking = create(:parking,aval_bike_spots: nil)
    expect(parking.aval_bike_spots).to eq(parking.total_bike_spots)
  end

  it "should not valid if longitude is not present" do
    parking = build(:parking,longitude: nil)
    expect(parking).to_not be_valid
  end
  it "should not validate if latitude is not present" do
    parking = build(:parking,latitude: nil)
    expect(parking).to_not be_valid
  end

  it "should have distance_from_user attribute" do
    parking = create(:parking,distance_from_user: 100)
    expect(parking.distance_from_user).to eq(100)
  end
end
