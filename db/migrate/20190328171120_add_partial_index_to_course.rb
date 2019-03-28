class AddPartialIndexToCourse < ActiveRecord::Migration[5.2]
  def change
    add_index :courses, %i[title is_active], unique: true, where: "is_active IS true"
  end
end
