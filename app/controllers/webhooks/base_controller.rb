class Webhooks::BaseController < ApplicationController
  # disable CSRF checks on webhooks because they do not originate from the browser
  # skip_before_action :verify_authentication_token
  skip_forgery_protection

  before_action :verify_event

  def create
    InboundWebhook.create!(body: payload)
    head :ok
  end


  def payload
    @payload ||= request.body.read
  end

  private

  def verify_event
    head :bad_request
  end


end
