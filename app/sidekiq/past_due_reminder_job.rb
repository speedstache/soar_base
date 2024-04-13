require 'sidekiq-scheduler'

class PastDueReminderJob
  include Sidekiq::Worker

  def perform
    reservations = Reservation.where(reservation_date: 100.days.ago..5.days.ago, status: 'open')
    reservations = reservations.where.not(aircraft_id: [9,7]).order('reservation_date DESC')

      reservations.each do |reservation|
      ReservationMailer.past_due(reservation).deliver_later
      end
  
  end
end
