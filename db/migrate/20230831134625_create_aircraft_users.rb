class CreateAircraftUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :aircraft_users do |t|
      t.integer :user_id
      t.integer :aircraft_id
    end
  end
end
