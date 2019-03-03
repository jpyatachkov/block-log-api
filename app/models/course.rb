class Course < ApplicationRecord
  after_create :set_user_permissions, :add_user_course_link
  resourcify
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true

  def set_user_permissions
    user = User.find(user_id)
    user.add_role :moderator, self
  end

  def add_user_course_link
    user = User.find(user_id)
    CourseUser.create!(user: user, course: self)
  end

  def destroy
    self.is_active = false
    save
  end
end