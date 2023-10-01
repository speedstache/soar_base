class CreateInboundWebhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :inbound_webhooks do |t|
      t.string :status, default: :pending
      t.text :body

      t.timestamps
    end
  end
end
