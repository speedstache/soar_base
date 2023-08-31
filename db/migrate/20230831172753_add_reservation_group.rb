class AddReservationGroup < ActiveRecord::Migration[7.0]
  def change
    create_table :aircraft_groups do |t|
      t.string :group
    end
  end
end
