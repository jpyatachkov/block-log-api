class AddIsCorrectFlagToSolution < ActiveRecord::Migration[5.2]
  def change
    add_column :solutions, :is_correct, :boolean, default: false
  end
end
