require "test_helper"

class Webhooks::ReservationControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def setup
    file_path = Rails.root.join("test", "fixtures", "webhooks", "reservation.json")
    @webhook = JSON.parse(File.read(file_path))
  end

  test "should consume webhook" do
    assert_difference "InboundWebhook.count" do
      post webhooks_reservation_url, params: @webhook
    end
    assert_enqueued_jobs 1
    assert_response :ok
  end

  test "should not consume webhook if verification failed" do
    assert_no_difference "InboundWebhook.count" do
      post webhooks_reservation_url(fail_verification: 1), params: @webhook
    end
    assert_enqueued_jobs 0
    assert_response :bad_request
  end

end
