class ChangeAssignmentTextColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :assignments, :text, :description
  end
end
