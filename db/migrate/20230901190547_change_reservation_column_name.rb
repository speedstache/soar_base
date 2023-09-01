class ChangeReservationColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :reservations, :reservation_time_start, :reservation_time
  end
end
