Rails.configuration.stripe = { 
  :publishable_key => Rails.application.credentials.stripe[:stripe_public_key]
  :secret_key => Rails.application.credentials.stripe[:stripe_private_key]
} 
Stripe.api_key = Rails.configuration.stripe[:stripe_private_key]