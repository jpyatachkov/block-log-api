class ChangeSolutionContentColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :solutions, :content, :program
  end
end
