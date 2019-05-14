class Course < ApplicationRecord
  resourcify

  has_many :commentary
  has_many :course_users

  validates :title, presence: true
  validates :short_description, presence: true
  validates :description, presence: true
  validates :requirements, presence: true
  validates :complexity, presence: true, inclusion: 1..5

  after_create :set_user_permissions,
               :add_user_course_link

  def self.all_visible_to(current_user)
    belongs_to = self.all_belongs_to(current_user)
    visible = self.all_visible

    self
        .from("(#{belongs_to.to_sql} UNION #{visible.to_sql}) AS courses")
        .joins("LEFT JOIN course_users on courses.id = course_users.course_id AND course_users.user_id = #{current_user.id}")
        .select('courses.*, course_users.count_passed, course_users.passed')
  end

  def self.all_belongs_to_and_passed(current_user, passed)
    self
        .all_belongs_to(current_user)
        .joins('LEFT JOIN course_users on courses.id = course_users.course_id')
        .where('course_users.user_id = ?', current_user.id)
        .select('courses.*, course_users.count_passed, course_users.passed')
        .where('course_users.passed = ?', passed)
  end

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

  def author
    User.find_by_id(user_id)
  end

  def self.get_course(id)
    self.find_by_id(id)
  end

  protected

  def self.all_belongs_to(current_user)
    current_user_courses = current_user.all_course_ids_of_with_rights %i[moderator collaborator user]

    if current_user.has_role?(:moderator, Course) || current_user.has_role?(:collaborator, Course)
      self.where(id: current_user_courses, is_active: true)
    else
      self.where(id: current_user_courses, is_active: true, is_visible: true)
    end
  end

  def self.all_visible
    self.where(is_active: true, is_visible: true)
  end

  def set_user_permissions
    user = User.find(user_id)
    user.add_role :moderator, self
  end

  def add_user_course_link
    user = User.find(user_id)
    CourseUser.create!(user: user, course: self)
  end
end
