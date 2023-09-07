class CreateTowfees < ActiveRecord::Migration[7.0]
  def change
    create_table :towfees do |t|
      t.integer :min_height
      t.integer :max_height
      t.float :price_per
      t.timestamps
    end
  end
end
