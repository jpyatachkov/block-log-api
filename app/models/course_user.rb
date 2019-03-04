class CourseUser < ApplicationRecord
  validates :user_id, uniqueness: { scope: :course_id }

  belongs_to :user
  belongs_to :course

  after_create :add_user_role_to_course

  protected

  def add_user_role_to_course
    User.find(user_id).add_role :user, Course.find(course_id)
  end
end
