class ChangeReservationTable < ActiveRecord::Migration[7.0]
  def change
    change_column :reservations, :reservation_time_start, :string
  end
end
