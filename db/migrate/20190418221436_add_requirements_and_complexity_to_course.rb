class AddRequirementsAndComplexityToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :requirements, :string
    add_column :courses, :complexity, :integer
  end
end
