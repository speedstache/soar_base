class ChangeDataTypeForReservationId < ActiveRecord::Migration[7.0]
  def change
    change_column :tows, :reservation_id, :integer
  end
end
