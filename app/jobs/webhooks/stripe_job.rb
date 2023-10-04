class Webhooks::StripeJob < ApplicationJob
  queue_as :default
  require 'stripe'

  def perform(inbound_webhook)
    json = JSON.parse(inbound_webhook.body, symbolize_names: true)
    event = Stripe::Event.construct_from(json)

    case event.type
      when "payment_intent.succeeded"
        inbound_webhook.update!(status: :processed)
      else
        inbound_webhook.update!(status: :skipped)
    end
  end
end
