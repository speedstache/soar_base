class AddProfileImageFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profile_images do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.binary :image_data, null: false
      t.string :content_type, null: false

      t.timestamps
    end
  end
end
