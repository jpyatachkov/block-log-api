class AddProgramToAssignment < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :program, :text
  end
end
