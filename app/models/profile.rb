class Profile < ApplicationRecord
  belongs_to :user

  before_save { |profile| profile.phone_number = phone_number.gsub(/[^0-9]/, "") }
  before_save { |profile| profile.emergency_phone = emergency_phone.gsub(/[^0-9]/, "") }

end