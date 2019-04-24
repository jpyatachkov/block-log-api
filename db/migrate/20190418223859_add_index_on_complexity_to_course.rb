class AddIndexOnComplexityToCourse < ActiveRecord::Migration[5.2]
  def change
    add_index :courses, :complexity
  end
end
