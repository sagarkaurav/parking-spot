class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :token
      t.string :license
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :vehicle_type
      t.timestamp :checkin_time
      t.timestamp :checkout_time
      t.integer :booked_hours
      t.integer :status
      t.monetize :online_amount
      t.monetize :offline_amount
      t.monetize :total_amount
      t.integer  :parking_id
      t.integer  :user_id, null: true
      t.timestamps
    end
    add_index :tickets, :token
    add_index :tickets, :status
    add_index :tickets, :user_id
    add_index :tickets, :phone_number
  end
end
