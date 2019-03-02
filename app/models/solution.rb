class Solution < ApplicationRecord
  validates :content, presence: true

  belongs_to :assignment

  def self.find_all(assignment_id, current_user)
    assignment = Assignment.find(assignment_id)
    if current_user.has_role? %i[moderator collaborator], assignment.course
      return Solution.where(assignment_id: assignment_id)
    end

    Solution.where(assignment_id: assignment_id, user_id: current_user.id)
  end
end
