class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.integer :user_id
      t.boolean :user_admin
      t.boolean :club_admin
      t.boolean :site_admin
      t.boolean :global_admin
      t.timestamps
    end
  end
end
