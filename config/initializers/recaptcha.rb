Recaptcha.configure do |config|
  config.site_key = ENV['RECAPTCHA_SITE_KEY'] || Rails.application.credentials.recaptcha_v2.site_key
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY'] || Rails.application.credentials.recaptcha_v2.secret_key
end