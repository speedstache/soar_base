class AddUserToTows < ActiveRecord::Migration[7.0]
  def change
    add_column :tows, :user_id, :integer
  end
end
