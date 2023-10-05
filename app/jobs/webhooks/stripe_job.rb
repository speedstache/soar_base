class Webhooks::StripeJob < ApplicationJob
  queue_as :default
  require 'stripe'

  def perform(inbound_webhook)
    json = JSON.parse(inbound_webhook.body, symbolize_names: true)
    event = Stripe::Event.construct_from(json)

    case event.type
      when "payment_intent.succeeded"
        inbound_webhook.update!(status: :processed)
      when "checkout.session.completed" 
        inbound_webhook.update!(status: :processed)
        #update! status column to paid when checkout session is completed
        Reservation.find(json[:data][:object][:client_reference_id]).update!(status: :paid)
      else
        inbound_webhook.update!(status: :skipped)
    end
  end
end
