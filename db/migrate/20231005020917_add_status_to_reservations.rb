class AddStatusToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :status, :string, default: 'open'
  end
end
