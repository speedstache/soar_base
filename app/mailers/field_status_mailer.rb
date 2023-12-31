class FieldStatusMailer < ApplicationMailer

  def field_status(field_status_update)
    @field_status_update = field_status_update
    @flying = @field_status_update.ops_status ? 'Yes' : 'No'

    mail to: "eagleville-soaring-club-members@googlegroups.com", subject: "Eagleville Soaring Club - Are we Flying? "+@flying
  end
  
end