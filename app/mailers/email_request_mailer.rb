class EmailRequestMailer < ApplicationMailer

  def forward(email, id)
    @email_contents = EmailRequest.find(id)

    @recipient = email

    mail to: @recipient, subject: "ESC Email Forward - "+@email_contents.subject
  end

  def trello_ride(id)
    @email_contents = EmailRequest.find(id)

    @recipient = "nathantaylor14+pn4hbmnlhskzqhi7807b@boards.trello.com"

    mail to: @recipient, subject: @email_contents.date.strftime("%x")+" Ride Request - "+@email_contents.email
  end

  def trello_member(id)
    @email_contents = EmailRequest.find(id)

    @recipient = "nathantaylor14+jsdrvr71eskj9rkd7yjm@boards.trello.com"

    mail to: @recipient, subject: @email_contents.date.strftime("%x")+" Membership Request - "+@email_contents.email
  end

  def secretary_forward(id)
    @email_contents = EmailRequest.find(id)

    @recipient = "nathan.r.taylor@gmail.com"

    mail to: @recipient, subject: "ESC Email Forward - "+@email_contents.subject
  end




end