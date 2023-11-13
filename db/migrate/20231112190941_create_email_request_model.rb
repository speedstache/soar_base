class CreateEmailRequestModel < ActiveRecord::Migration[7.0]
  def change
    create_table :email_request do |t|
      t.date :date
      t.string :email
      t.string :subject
      t.text :body
      t.boolean :ride
      t.boolean :general
      t.boolean :membership
      t.boolean :instruction

      t.timestamps
    end
  end
end
