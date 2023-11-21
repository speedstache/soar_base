class Profile < ApplicationRecord
  before_validation :set_defaults
  belongs_to :user

  def set_defaults
    self.phone_number ||= '0000000000'
    self.emergency_phone ||= '0000000000'
  end

  before_save { |profile| profile.phone_number = phone_number.gsub(/[^0-9]/, "") }
 
  before_save { |profile| profile.emergency_phone = emergency_phone.gsub(/[^0-9]/, "") }

end