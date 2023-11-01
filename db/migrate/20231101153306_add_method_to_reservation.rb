class AddMethodToReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :method, :string
    add_column :reservations, :description, :string
  end
end
