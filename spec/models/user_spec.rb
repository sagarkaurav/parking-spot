require 'rails_helper'

RSpec.describe User, type: :model do
  it "should not valid if user first name is empty string" do
    user = build(:user,first_name: '  ')
    expect(user).to_not be_valid
  end

  it "should not valid if user last name is nil" do
    user = build(:user,last_name: nil)
    expect(user).to_not be_valid
  end

  it "should not valid if phone_number string is less than 10 character" do
    user = build(:user,phone_number: '987654321')
    expect(user).to_not be_valid
  end

  it "should not valid if phone_number string is more than 10 character" do
    user = build(:user,phone_number: '98765432101')
    expect(user).to_not be_valid
  end

  it "should not valid if phone_number string any other non numeric character" do
    user = build(:user,phone_number: '98b65432101')
    expect(user).to_not be_valid
  end
end
