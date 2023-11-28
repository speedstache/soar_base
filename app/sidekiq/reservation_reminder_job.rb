require 'sidekiq-scheduler'

class ReservationReminderJob
  include Sidekiq::Worker

  def perform
    reservations = Reservation.where(reservation_date: Date.today..1.day.from_now)

      reservations.each do |reservation|
      ReservationMailer.reminder(reservation).deliver_later
      end
  
  end
end