FactoryGirl.define do
  factory :parking do
    name 'Foo parking'
    address 'Foo parking address'
    total_car_spots 100
    total_bike_spots 100
    aval_bike_spots 100
    aval_car_spots 100
    car_price 10
    bike_price 5
    longitude 10.000000
    latitude 10.000000
    association :city, factory: :city
  end
end
