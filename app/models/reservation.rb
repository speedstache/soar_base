class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :aircraft
  has_many :flights
  accepts_nested_attributes_for :flights
  attribute :reservation_duration, :integer, default: 60
  validates :reservation_date, uniqueness: {scope: [:reservation_date, :reservation_time, :aircraft_id]}
  validates :aircraft_id, uniqueness: {scope: [:reservation_date, :reservation_time, :aircraft_id]}

  #define useful scope for retrieving data
   scope :res_date, lambda  {where(reservation_date: "?")}

end