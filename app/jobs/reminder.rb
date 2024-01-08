class Reminder < ApplicationJob
  queue_as :default

  def perform
    reservations = Reservation.where(reservation_date: 1.day.from_now(Time.now))

      reservations.each do |reservation|
      ReservationMailer.reminder(reservation).deliver_later
      end

end 