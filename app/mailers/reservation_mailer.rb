class ReservationMailer < ApplicationMailer

  def confirmation(reservation)
    @reservation = reservation
    mail to: @reservation.user.email, subject: "Eagleville Soaring Club - Reservation Confirmation"
  end

  def deletion(reservation)
    @reservation = reservation
    mail to: @reservation.user.email, subject: "Eagleville Soaring Club - Reservation Deleted"
  end

  def update(reservation)
    @reservation = reservation
    mail to: @reservation.user.email, subject: "Eagleville Soaring Club - Reservation Updated"
  end

  def reminder(reservation)
    @reservation = reservation
    mail to: @reservation.user.email, subject: "Eagleville Soaring Club - Reservation Tomorrow"
  end
  
end