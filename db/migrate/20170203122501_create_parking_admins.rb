class CreateParkingAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :parking_admins do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :password_digest
      t.integer :parking_id
      t.timestamps
    end
    add_index :parking_admins, :user_name
    add_index :parking_admins, :password_digest
  end
end
