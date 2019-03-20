class AddStaffFlagToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_staff, :boolean, default: false
  end
end
