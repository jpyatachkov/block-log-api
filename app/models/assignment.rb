class Assignment < ApplicationRecord
  resourcify

  has_many :commentary

  validates :text, presence: true
  validates :user_id, presence: true

  belongs_to :course

  after_create :add_user_assignment_link

  protected

  def add_user_assignment_link
    AssignmentUser.create!(user: User.find(user_id), assignment: self)
  end
end
