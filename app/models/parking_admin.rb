class ParkingAdmin < ApplicationRecord
  belongs_to :parking
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :user_name, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum:6,maximum:20}
end
