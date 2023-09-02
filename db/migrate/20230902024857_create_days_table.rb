class CreateDaysTable < ActiveRecord::Migration[7.0]
  def change
    create_table :days do |t|
        t.date :day
        t.boolean :active_flag
      t.timestamps
    end
  end 
end
