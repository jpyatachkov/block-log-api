class Course < ApplicationRecord
  resourcify

  has_many :commentary

  validates :title, presence: true
  validates :description, presence: true

  after_create :set_user_permissions,
               :add_user_course_link

  def destroy
    self.is_active = false
    save
  end

  def save
    super
  rescue ActiveRecord::RecordNotUnique
    @errors.add(:title, I18n.t(:course_exist))
    false
  end

  protected

  def set_user_permissions
    user = User.find(user_id)
    user.add_role :moderator, self
  end

  def add_user_course_link
    user = User.find(user_id)
    CourseUser.create!(user: user, course: self)
  end
end
