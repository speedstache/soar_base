class AddArchiveToEmailRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :email_requests, :archive, :boolean
  end
end
