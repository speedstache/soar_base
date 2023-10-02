if Rails.application.credentials[:stripe][:production].present? && Rails.application.credentials[:stripe][:production][:secret_key].present?
  Stripe.api_key = Rails.application.credentials[:stripe][:production][:secret_key]
end