class Course < ApplicationRecord
  resourcify

  has_many :commentary
  has_many :course_users

  mount_uploader :image, CourseImageUploader

  validates :title, presence: true
  validates :short_description, presence: true
  validates :description, presence: true
  validates :requirements, presence: true
  validates :complexity, presence: true, inclusion: 1..5

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

  def visible(user)
    is_visible ? true : user.has_role?(%i[moderator collaborator], self)
  end

  def self.get_course(id)
    Course.find_by_id(id)
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
