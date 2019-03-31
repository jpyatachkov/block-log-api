class Solution < ApplicationRecord
  validates :program, presence: true

  belongs_to :assignment
  belongs_to :course

  has_many :commentary

  def self.find_all(assignment_id, current_user)
    assignment = Assignment.find(assignment_id)

    if current_user.has_role? %i[moderator collaborator], assignment.course
      Solution.where(assignment_id: assignment_id)
    else
      Solution.where(assignment_id: assignment_id, user_id: current_user.id)
    end
  end
end
