class AddFieldsToAssignmentUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :assignment_users, :count_attempts, :integer, default: 0
    add_column :assignment_users, :course_id, :integer
    add_column :assignment_users, :is_correct, :boolean, default: false
    add_column :assignment_users, :solution_id, :integer
  end
end
