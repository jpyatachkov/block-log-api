class CourseUser < ApplicationRecord
  after_create :add_user_role_to_course

  validates :user_id, uniqueness: { scope: :course_id }

  belongs_to :user
  belongs_to :course

  def add_user_role_to_course
    user = User.find(user_id)
    course = Course.find(course_id)
    user.add_role(:user, course)
  end
end
