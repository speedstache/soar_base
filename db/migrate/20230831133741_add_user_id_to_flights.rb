class AddUserIdToFlights < ActiveRecord::Migration[7.0]
  def change
    add_column :flights, :user_id, :integer
  end
end
