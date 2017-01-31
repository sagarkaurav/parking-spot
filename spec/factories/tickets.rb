FactoryGirl.define do
  factory :ticket do
    token nil
    license 'ABC1020'
    first_name 'ABC'
    last_name 'XYZ'
    phone_number '0987654321'
    vehicle_type 'car'
    checkin_time Time.now.change(min:0,sec:0)
    checkout_time nil
    booked_hours 10
    status 0
    online_amount 0
    offline_amount 0
    total_amount 0
    association :parking, factory: :parking
  end
end
