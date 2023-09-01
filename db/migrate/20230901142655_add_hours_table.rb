class AddHoursTable < ActiveRecord::Migration[7.0]
  def change
    create_table :hours do |t|
      t.string :hour
      t.boolean :active_flag
    end
  end
end
