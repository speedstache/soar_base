class AddTachStartToTows < ActiveRecord::Migration[7.0]
  def change
    add_column :tows, :tach_start, :float
  end
end
