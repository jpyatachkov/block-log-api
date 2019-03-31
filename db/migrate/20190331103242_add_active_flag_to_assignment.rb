class AddActiveFlagToAssignment < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :is_active, :boolean, default: true
  end
end
