class AddCommPilotToPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :permissions, :commercial, :boolean
  end
end
