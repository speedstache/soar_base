class CreateAircrafts < ActiveRecord::Migration[7.0]
  def change
    create_table :aircrafts do |t|
      t.string :name
      t.string :short_name
      t.string :reservation_group
      t.date :last_maintenance
      t.boolean :active_flag
      t.timestamps
    end
  end
end
