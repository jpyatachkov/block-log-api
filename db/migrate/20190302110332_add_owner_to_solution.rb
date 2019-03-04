class AddOwnerToSolution < ActiveRecord::Migration[5.2]
  def change
    add_reference :solutions, :user, foreign_key: true
  end
end
