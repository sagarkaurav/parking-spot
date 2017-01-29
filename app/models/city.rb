class City < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  before_create :downcase_name_code
  before_validation :upcase_code

  protected

  def downcase_name_code
    self.name.downcase!
    self.code.upcase!
  end

  def upcase_code
    if !self.code.blank?
      self.code.upcase!
    end
  end
end
