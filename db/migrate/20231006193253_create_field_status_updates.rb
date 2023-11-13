class CreateFieldStatusUpdates < ActiveRecord::Migration[7.0]
  def change
    create_table :field_status_updates do |t|
      t.string :username
      t.date :date
      t.boolean :ops_status
      t.string :title
      t.text :notes

      t.timestamps
    end
  end
end