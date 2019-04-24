class AddAdditionalFieldsToCourseUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :course_users, :passed, :boolean, default: false
    add_column :course_users, :count_passed, :integer, default: 0
  end
end
