require 'sendgrid-ruby'
include SendGrid

from = SendGrid::Email.new(email: 'clubadmin@eagleville.com', name: "Test") # Change to your verified sender
to = SendGrid::Email.new(email: 'nathan.r.taylor@gmail.com', name: "Test") # Change to your recipient
subject = 'Sending with Twilio SendGrid is Fun'
content = SendGrid::Content.new(type: 'text/html', value: 'and easy to do anywhere, even with <strong>Ruby</strong>.')
mail = SendGrid::Mail.new(from, subject, to, content)

sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
response = sg.client.mail._('send').post(request_body: mail.to_json)
puts response.status_code
puts response.headers