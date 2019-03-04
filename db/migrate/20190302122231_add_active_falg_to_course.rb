class AddActiveFalgToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :is_active, :bool, default: true
  end
end
