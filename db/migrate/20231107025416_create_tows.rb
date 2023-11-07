class CreateTows < ActiveRecord::Migration[7.0]
  def change
    create_table :tows do |t|
      t.string :reservation_id
      t.date :tow_date
      t.integer :aircraft_id
      t.integer :tows
      t.integer :releases
      t.float :tach_end
      t.integer :fuel_added
      t.integer :oil_added

      t.timestamps
    end
  end
end
