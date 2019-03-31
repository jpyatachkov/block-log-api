class AddTitleToAssignment < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :title, :text
  end
end
