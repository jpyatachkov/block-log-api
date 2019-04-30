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
      already_correct = assignment_user.is_correct
    end
    p already_correct

    assignment_user.count_attempts += 1

    if is_correct
      assignment_user.is_correct = true
      assignment_user.solution_id = id
    end
    assignment_user.save

    if is_correct && !already_correct
      Solution.check_course_state(course_id, user_id)
    end
  end

  def self.check_course_state(c_id, u_id)
    course_assignments = Assignment.where(course_id: c_id, is_active: true).select(:id).map(&:id)
    
    passed_assignments = AssignmentUser.where(course_id: c_id, user_id: u_id, is_correct: true)
                                       .select(:assignment_id).map(&:assignment_id)

    assignments_size = course_assignments.size
    course_assignments -= passed_assignments

    course_user = CourseUser.where(user: u_id, course: c_id).first
    course_user.count_passed = passed_assignments.size

    if course_assignments.empty?
      course_user.passed = true
      course_user.count_passed = assignments_size
    end
    course_user.save
  end
end