class AddCountAssginmentsToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :count_assignments, :integer, default: 0
  end
end
