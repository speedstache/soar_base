class Webhooks::ReservationsJob < ApplicationJob
  queue_as :default

  def perform(inbound_webhook)
    webhook_payload = JSON.parse(inbound_webhook.body, symbolize_names: true)

    inbound_webhook.update(status: :processed)
  end
end
