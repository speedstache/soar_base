class CreateProfileTable < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :phone_number
      t.string :emergency_contact
      t.string :emergency_phone
      t.date :date_of_birth
      t.string :street_first_line
      t.string :street_second_line
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
