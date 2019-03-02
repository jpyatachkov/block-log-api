class Assignment < ApplicationRecord
  after_create :add_user_assignment_link
  resourcify
  validates :text, presence: true

  belongs_to :course

  def add_user_assignment_link
    user = User.find(user_id)
    AssignmentUser.create!(user: user, assignment: self)
  end
end
