class AddInstructorToPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :permissions, :instructor, :boolean
  end
end
