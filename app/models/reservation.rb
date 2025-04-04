class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :aircraft
  has_many :flights, dependent: :destroy
  has_many :tows, dependent: :destroy
  has_one :day
  accepts_nested_attributes_for :flights, :tows
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

  #define the csv export format for the reservations grid and iterate through the model for each value
  def self.reservation_to_csv
    attributes = %w{id date name aircraft instructor flight_count flight_minutes tow_fees status payment_method description}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      @reservations = Reservation.where(reservation_date: 400.days.ago..Date.today, aircraft_id: Aircraft.where.not(group: 'towplane'))
      @reservations.each do |reservation|
          id = reservation.id
          date = reservation.reservation_date
          name = reservation.user.username
          aircraft = reservation.aircraft.short_name
          instructor = reservation.instructor_flag.humanize
          flight_count = reservation.flights.count
          flight_minutes = reservation.flights.pluck(:flight_time).sum
          tow_fees = if reservation.rth_flag == true then 180 else reservation.flights.pluck(:fees).sum end
          status = reservation.status 
          payment_method = reservation.method
          description = reservation.description
          csv << [id, date, name, aircraft, instructor, flight_count, flight_minutes, tow_fees, status, payment_method, description]
      end
    end

    
  end

  #define the csv export format for the reservations grid and iterate through the model for each value
  def self.towpilot_to_csv
    attributes = %w{id date name aircraft tow_count}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      @reservations = Reservation.where(reservation_date: 400.days.ago..Date.today, aircraft_id: Aircraft.where(group: 'towplane'))
      @reservations.each do |reservation|
          id = reservation.id
          date = reservation.reservation_date
          name = reservation.user.username
          aircraft = reservation.aircraft.short_name
          tow_count = reservation.tows.pluck(:tows).sum
          csv << [id, date, name, aircraft, tow_count]
      end
    end

    
  end

  def reservation_status
    if reservation.status == 'open' && reservation.reservation_date > Date.today
      reservation_status = 'Upcoming'
    elsif reservation.status == 'open' && reservation.reservation_date < 5.days.ago 
      reservation_status = 'Past_Due'
    else
      reservation_status = reservation.status
    end
    return reservation_status 
  end


end
