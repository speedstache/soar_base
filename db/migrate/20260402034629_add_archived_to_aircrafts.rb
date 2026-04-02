class AddArchivedToAircrafts < ActiveRecord::Migration[7.0]
  def change
    add_column :aircrafts, :archived, :boolean, default: false
  end
end
