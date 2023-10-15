class AddInstructorIdToFlights < ActiveRecord::Migration[7.0]
  def change
    add_column :flights, :instructor_id, :integer
  end
end
