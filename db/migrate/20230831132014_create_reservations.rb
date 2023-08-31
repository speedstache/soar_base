class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.date :reservation_date
      t.time :reservation_time_start
      t.integer :reservation_duration
      t.integer :aircraft_id
      t.boolean :instructor_flag
      t.timestamps
    end
  end
end
