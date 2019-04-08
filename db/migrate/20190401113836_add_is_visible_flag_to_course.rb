class AddIsVisibleFlagToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :is_visible, :boolean, default: true
  end
end
