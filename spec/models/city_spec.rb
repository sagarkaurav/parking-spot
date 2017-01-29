require 'rails_helper'

RSpec.describe City, type: :model do
  it "should create city in database" do
    expect(City.count).to eq(0)
    create(:city)
    expect(City.count).to eq(1)
  end
  it "should not valid if name is empty string" do
    city = build(:city,name: '')
    expect(city).to_not be_valid
  end

  it "should not valid if name is nil" do
    city = build(:city,name: nil)
    expect(city).to_not be_valid
  end

  it "should not valid if code is empty string" do
    city = build(:city,code: '')
    expect(city).to_not be_valid
  end

  it "should not valid if code is nil" do
    city = build(:city,code: nil)
    expect(city).to_not be_valid
  end

  it "should not valid if code in not unique" do
    create(:city)
    city = build(:city)
    expect(city).to_not be_valid
  end

  it "should have downcase name" do
    city = create(:city,name: "BHOPAL")
    expect(city.name).to eq("bhopal")
  end

  it "should have upcase code" do
    city = create(:city,code: 'bpl')
    expect(city.code).to eq('BPL')
  end
  it "should have upcase code on object updation" do
    city = create(:city)
    city.code = "bplnew"
    city.save
    expect(city.code).to eq('BPLNEW')
  end
end
