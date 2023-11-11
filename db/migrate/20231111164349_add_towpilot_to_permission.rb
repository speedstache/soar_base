class AddTowpilotToPermission < ActiveRecord::Migration[7.0]
  def change
    add_column :permissions, :towpilot, :boolean
  end
end
