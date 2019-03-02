class AddOwnerToAssignment < ActiveRecord::Migration[5.2]
  def change
    add_reference :assignments, :user, foreign_key: true
  end
end
