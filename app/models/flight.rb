class Flight < ApplicationRecord
  belongs_to :reservation
  belongs_to :aircraft
  belongs_to :user

  validates :tow_height, numericality: {greater_than_or_equal_to: 100,  only_integer: true }

  # method to determine the price of a tow based on a tow height

  def calcfees
    calcfees = 0
    rowfee = 0
    Towfee.pluck(:id).each do |id|
      calcfees += rowfee
      towfee = Towfee.find(id)
        if ( self.tow_height - towfee.min_height ) >= ( towfee.max_height - towfee.min_height ) && ( self.tow_height - towfee.min_height ) > 0
          rowfee =  ( ( towfee.max_height - towfee.min_height ) / 100 ) * towfee.price_per
        elsif ( self.tow_height - towfee.min_height ) <= ( towfee.max_height - towfee.min_height ) && ( self.tow_height - towfee.min_height ) > 0
          rowfee =  ( ( self.tow_height - towfee.min_height ) / 100 ) * towfee.price_per
        else
          rowfee =  0
        end
      end
    return calcfees
  end

  #define the csv export format for the flights grid and iterate through the model for each value
  def self.flight_to_csv
    attributes = %w{reservation_id flight_id date name aircraft instructor rth_ride flight_count flight_minutes tow_height tow_fees status payment_method description}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      @flights = Flight.where(flight_date: Date.today.beginning_of_year..Date.today).order('flights.flight_date DESC','flights.reservation_id ASC')

      #Change rth flight tow fees to $180, also do this in admin/flights.html.erb
      @flights.each do |flight|
          reservation_id = flight.reservation_id
          flight_id = flight.id
          date = flight.flight_date
          name = flight.user.username
          aircraft = flight.aircraft.short_name
          instructor = flight.reservation.instructor_flag.humanize
          rth_ride = flight.reservation.rth_flag.humanize
          flight_count = 1
          flight_minutes = flight.flight_time
          tow_height = flight.tow_height
          tow_fees = flight.reservation.rth_flag.present? ? 180.00 : flight.fees
          status = flight.reservation.status 
          payment_method = flight.reservation.method
          description = flight.reservation.description
          csv << [reservation_id, flight_id, date, name, aircraft, instructor, rth_ride, flight_count, flight_minutes, tow_height, tow_fees, status, payment_method, description]
      end
    end

  end

  #define the csv export format for the flights grid and iterate through the model for each value
  def self.instructor_to_csv
    attributes = %w{reservation_id flight_id date name aircraft instructor_name flight_minutes tow_height}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      @instructorflights = Flight.where.not(instructor_id: nil)
      @flights = @instructorflights.where(flight_date: 400.days.ago..Date.today).order('flights.flight_date DESC','flights.reservation_id DESC')

      #Change rth flight tow fees to $180, also do this in admin/flights.html.erb
      @flights.each do |flight|
          reservation_id = flight.reservation_id
          flight_id = flight.id
          date = flight.flight_date
          name = flight.user.username
          aircraft = flight.aircraft.short_name
          instructor_name = User.find(flight.instructor_id).username
          flight_minutes = flight.flight_time
          tow_height = flight.tow_height
          csv << [reservation_id, flight_id, date, name, aircraft, instructor_name, flight_minutes, tow_height]
      end
    end

  end

end
