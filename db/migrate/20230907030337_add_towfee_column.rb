class AddTowfeeColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :flights, :fees, :float
  end
end
