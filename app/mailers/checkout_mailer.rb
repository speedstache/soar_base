class CheckoutMailer < ApplicationMailer

  def stripe_success(reservation)
    @reservation = reservation
    mail to: @reservation.user.email, subject: "Your Eagleville Soaring Club Receipt - Reservation #"+@reservation.id.to_s

  end

end
