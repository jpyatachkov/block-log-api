class AddUniqueIndexToCourseUser < ActiveRecord::Migration[5.2]
  def change
    add_index :course_users, %i[user_id course_id], unique: true
  end
end
