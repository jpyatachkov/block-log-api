class Course < ApplicationRecord
  resourcify

  has_many :commentary

  validates :title, presence: true #, uniqueness: true
  validates :title, uniqueness: true, if: :validate_before_create, on: :create
  validates :title, uniqueness: true, if: :validate_before_update, on: :updaete  #:active_course_exists#, on: :create
  
  validates :description, presence: true

  after_create :set_user_permissions,
               :add_user_course_link

  def destroy
    self.is_active = false
    save
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

  def validate_before_create
    course = Course.where(title: title, is_active: true).count
    return course == 0 ? false : true
  end

  # refactor
  def validate_before_update
    if title.present? # on delete there is no title
      p title
      course = Course.where(title: title, is_active: true).first
      p course.id
      if course.nil?
        p 'nil'
        return false
      elsif course.id == id
        p 'id eq'
        return false
      end
      return true
    end
  end 
end
