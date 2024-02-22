
#if you are using the API key
ActionMailer::Base.smtp_settings = {
  domain: 'EAGLEVILLESOARING.ORG',
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      'apikey',
  password:       ENV['SENDGRID_API_KEY']
}