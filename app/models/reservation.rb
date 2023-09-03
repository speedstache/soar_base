class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :aircraft
  has_many :flights
  has_one :day
  accepts_nested_attributes_for :flights
  attribute :reservation_duration, :integer, default: 60
  validates :reservation_date, uniqueness: {scope: [:reservation_date, :reservation_time, :aircraft_id]}
  validates :aircraft_id, uniqueness: {scope: [:reservation_date, :reservation_time, :aircraft_id]}

  def self.search(search)
    if search
      show_date = Day.find_by(day: search)
      if show_date
        self.where(reservation_date: search)
      else
        Reservation.where(reservation_date: search)
      end
    else
      Reservation.where(reservation_date: Date.today)
    end
  end
end