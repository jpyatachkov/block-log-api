class Solution < ApplicationRecord
  validates :program, presence: true

  belongs_to :assignment
  belongs_to :course

  has_many :commentary

  after_create :create_or_update_assignment_solution

  def self.get_course(id)
    solution = Solution.find_by_id(id)
    solution.nil? ? nil : solution.course
  end

  def self.find_all(assignment_id, current_user)
    assignment = Assignment.find(assignment_id)

    if current_user.has_role? %i[moderator collaborator], assignment.course
      Solution.where(assignment_id: assignment_id)
    else
      Solution.where(assignment_id: assignment_id, user_id: current_user.id)
    end
  end

  protected

  def create_or_update_assignment_solution
    assignment_user = AssignmentUser.where(user_id: user_id, assignment_id: assignment).first

    already_correct = false

    if assignment_user.nil?
      assignment_user = AssignmentUser.new(user_id: user_id, 
                                                assignment_id: assignment_id,
                                                course_id: course_id)
    else
      old = assignment_user.is_correct
    end

    assignment_user.count_attempts += 1
    if is_correct
      assignment_user.solution_id = id

      if !already_correct
        assignment_user.is_correct = true
        check_course_state
      end
    end 

    assignment_user.save()
  end

  def check_course_state
    course_assignments = Assignment.where(course_id: course.id, is_active: true).select(:id).map(&:id)
    passed_assignments = AssignmentUser.where(course_id: course_id, user_id: user_id).select(:assignment_id).map(&:assignment_id)

    course_assignments -= passed_assignments

    course_user = CourseUser.where(user: user_id, course: course_id).first
    course_user.count_passed = passed_assignments.size()

    if course_assignments.empty?
      course_user.passed = true
    end
    course_user.save
  end
end
