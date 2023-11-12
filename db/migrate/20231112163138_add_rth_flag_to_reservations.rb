class AddRthFlagToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :rth_flag, :boolean
  end
end
