class Reservation < ApplicationRecord
  belongs_to :user
  has_one :aircraft
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

# returns a string of all aircraft that the user has reservation privileges in
  # this is of limited usefulness but prints the data in the AircraftUser table in a visual way
  def has_privileges_in(res_user_id)
    
    # will need to limit this to users that have active memberships once available
    aircraftuser_ids = AircraftUser.where(user_id: User.where(id: res_user_id))
      has_privileges_in = aircraftuser_ids.aircraft_ids
      
    return has_privileges_in

  end