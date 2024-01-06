class Reminder < ApplicationJob
  queue_as :default

  def perform
    reservations = Reservation.where(reservation_date: Date.today..0.day.from_now)

      reservations.each do |reservation|
      ReservationMailer.reminder(reservation).deliver_later
      end

  end

end 