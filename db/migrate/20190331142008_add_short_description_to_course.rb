class AddShortDescriptionToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :short_description, :text
  end
end
