class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights do |t|
      t.integer :reservation_id
      t.date :flight_date
      t.integer :aircraft_id
      t.integer :flight_time
      t.integer :tow_height
      t.boolean :rope_break
      t.timestamps
    end
  end
end
