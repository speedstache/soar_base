class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.string :membership_type
      t.integer :renewal_period
      t.integer :renewal_price
      t.boolean :active_flag
      t.timestamps
    end
  end
end
