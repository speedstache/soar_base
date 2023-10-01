class Webhooks::ReservationController < Webhooks::BaseController
  # curl -X POST http://localhost:3000/webhooks/reservation -H 'Content-Type: application/json' -d '{"user": "Nathan"}'

  def create
 
    record = InboundWebhook.create!(body: payload)
    Webhooks::ReservationsJob.perform_later(record)
    head :ok
  end

  private

  def verify_event
    head :bad_request if params[:fail_verification]
  end

end