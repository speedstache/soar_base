class CreateMembershipUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :membership_users do |t|
        t.integer :user_id
        t.integer :membership_id
        t.date :renewal_date
        t.boolean :active_flag
      t.timestamps
    end
  end
end
