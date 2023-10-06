class FieldStatusMailer < ApplicationMailer

  def field_status(field_status_update)
    @field_status_update = field_status_update
    mail to: "nathan.r.taylor@gmail.com", subject: "Eagleville Soaring Club - Field Operation Status"
  end
  
end