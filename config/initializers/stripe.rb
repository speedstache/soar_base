Rails.configuration.stripe = { 
  :publishable_key => Rails.application.credentials.dig[:stripe, :stripe_public_key],
  :secret_key => Rails.application.credentials.dig[:stripe, :stripe_private_key]
} 
Stripe.api_key = Rails.configuration.dig[:stripe, :stripe_private_key]