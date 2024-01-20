require 'sidekiq-scheduler'

class WebhookCleanup
  include Sidekiq::Worker

  def perform

    #delete any webhook more than 30 days old
    
    old_webhooks = InboundWebhook.where.not(created_at: 30.days.ago..Date.today)
    skipped_webhooks = old_webhooks.where(status: "skipped")

    skipped_webhooks.each do |skipped_webhook|
      skipped_webhook.destroy
    end
    
  end
  
end