class AssignmentSolution < ApplicationRecord
  validates :user_id, presence: true
  validates :assignment_id, presence: true

  belongs_to :user
  belongs_to :assignment
end
