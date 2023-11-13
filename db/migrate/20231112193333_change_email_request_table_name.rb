class ChangeEmailRequestTableName < ActiveRecord::Migration[7.0]
  def change
    rename_table :email_request, :email_requests
  end
end
