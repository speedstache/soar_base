class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :aircraft
  has_many :flights
  has_one :day
  accepts_nested_attributes_for :flights
  attribute :reservation_duration, :integer, default: 60
  validates :reservation_date, uniqueness: {scope: [:reservation_date, :reservation_time, :aircraft_id]}
  validates :aircraft_id, uniqueness: {scope: [:reservation_date, :reservation_time, :aircraft_id]}

  def self.search_date
    find_date = Day.order('days.day ASC').where(day: Date.today.., active_flag: true).first
    search_date = find_date.day
    return search_date
  end

  def self.search(search)
    if search
      show_date = Day.find_by(day: search)
      if show_date
        self.where(reservation_date: search)
      else
        Reservation.where(reservation_date: search)
      end
    else
      Reservation.where(reservation_date: search_date)
    end
  end

  def self.to_csv
    attributes = %w{id date name aircraft instructor flight_count flight_minutes tow_fees status payment_method description}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      @reservations = Reservation.all
      @reservations.each do |reservation|
          id = reservation.id
          date = reservation.reservation_date
          name = reservation.user.username
          aircraft = reservation.aircraft.short_name
          instructor = reservation.instructor_flag.humanize
          flight_count = reservation.flights.count
          flight_minutes = reservation.flights.pluck(:flight_time).sum
          tow_fees = reservation.flights.pluck(:fees).sum
          status = reservation.status
          payment_method = reservation.method
          description = reservation.description
          csv << [id, date, name, aircraft, instructor, flight_count, flight_minutes, tow_fees, status, payment_method, description]
      end
    end

  end
    

end
