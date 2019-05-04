class Assignment < ApplicationRecord
  resourcify

  has_many :commentary
  has_many :assignment_users

  validates :title, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  belongs_to :course

  after_create :increment_course_assignmetns
  after_create :add_user_assignment_link

  def destroy
    self.is_active = false
    course.count_assignments -= 1
    course_users = CourseUser.where(course_id: course_id)
    course.save
    save

    # this may not correct
    course_users.each do |course_user|
      Solution.check_course_state(course_id, course_user.user)
    end
  end

  def self.get_course(id)
    assignment = Assignment.find_by_id(id)
    assignment.nil? ? nil : assignment.course
  end

  protected

  def increment_course_assignmetns
    course.count_assignments += 1
    ###
    CourseUser.where(course_id: course_id).update_all(passed: false)
    course.save
  end

  def add_user_assignment_link
    AssignmentUser.create!(user: User.find(user_id), assignment: self, course_id: course.id)
  end
end
