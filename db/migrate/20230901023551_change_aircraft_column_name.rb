class ChangeAircraftColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :aircrafts, :group_id, :group
  end
end
