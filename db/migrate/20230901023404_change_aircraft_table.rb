class ChangeAircraftTable < ActiveRecord::Migration[7.0]
  def change
    change_column :aircrafts, :group_id, :string
  end
end
