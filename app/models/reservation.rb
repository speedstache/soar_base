class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :aircraft
  has_many :flights
  accepts_nested_attributes_for :flights
  attribute :reservation_duration, :integer, default: 60
end
