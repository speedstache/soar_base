class AddJoinedDateToMembershipuser < ActiveRecord::Migration[7.0]
  def change
    add_column :membership_users, :joined_date, :date
  end
end
