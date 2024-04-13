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

  def past_due(reservation)
    @reservation = reservation
    mail to: "nathan_r_taylor@gmail.com", subject: "Eagleville Soaring Club - Reservation Past Due"
  end
  
end