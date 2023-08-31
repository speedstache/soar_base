class DropAdminFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :user, :admin
  end
end
