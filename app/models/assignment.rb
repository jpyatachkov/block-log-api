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

  def self.all_from_course_visible_to(course_id, current_user)
    self
        .where(course_id: course_id, is_active: true)
        .where('assignment.is_visible = ? OR assignment_users.user_id = ?', true, current_user.id)
        .or(Assignment.where course_id: course_id, is_active: true)
        .joins('LEFT JOIN assignment_users on assignments.id = assignment_users.assignment_id')
        .select('assignments.*, assignment_users.count_attempts, assignment_users.is_correct')
        .distinct
  end

  def self.get_course(id)
    assignment = self.find_by_id(id)
    assignment.nil? ? nil : assignment.course
  end

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
