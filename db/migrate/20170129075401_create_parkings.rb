class CreateParkings < ActiveRecord::Migration[5.0]
  def change
    create_table :parkings do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.integer :total_car_spots, null: false
      t.integer :total_bike_spots, null: false
      t.integer :aval_car_spots, null: false
      t.integer :aval_bike_spots, null: false
      t.monetize :car_price, null: false
      t.monetize :bike_price, null: false
      t.decimal :longitude, precision:8, scale: 6
      t.decimal :latitude, precision:8, scale: 6
      t.integer :city_id
      t.timestamps
    end
    add_index :parkings, :address
    add_index :parkings, :city_id
  end
end
