class SetNilToFalseEmailRequests < ActiveRecord::Migration[7.0]
  def change
    change_column :email_requests, :ride, :boolean, :default => false
    change_column :email_requests, :instruction, :boolean, :default => false
    change_column :email_requests, :membership, :boolean, :default => false
    change_column :email_requests, :general, :boolean, :default => false
    change_column :email_requests, :archive, :boolean, :default => false

  end
end
