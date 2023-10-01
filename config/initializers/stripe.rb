Rails.configuration.stripe = { 
  :publishable_key => Rails.application.credentials.dig(:stripe_public_key),
  :secret_key => Rails.application.credentials.dig(:stripe_private_key)
} 
Stripe.api_key = Rails.configuration.stripe(:secret_key)