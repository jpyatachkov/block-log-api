class CourseUser < ApplicationRecord
  validates :user_id, uniqueness: { scope: :course_id }
  belongs_to :user
  belongs_to :course

  after_create :add_user_role_to_course

  protected

  def add_user_role_to_course
    user = User.find(user_id)
    role = user.has_role?(:moderator, Course) ? :collaborator : :user
    user.add_role role, Course.find(course_id)
  end
end
