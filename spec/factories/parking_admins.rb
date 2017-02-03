FactoryGirl.define do
  factory :parking_admin do
    first_name 'sagar'
    last_name 'kaurav'
    user_name 'sagar313'
    password  'slimshady'
    association :parking, factory: :parking
  end
end
