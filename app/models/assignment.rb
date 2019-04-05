class Assignment < ApplicationRecord
  resourcify

  has_many :commentary

  validates :title, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  belongs_to :course

  after_create :add_user_assignment_link

  def destroy
    self.is_active = false
    save
  end

  def self.get_course(id)
    assignment = Assignment.find_by_id(id)
    assignment.nil? ? nil : assignment.course
  end

  protected

  def add_user_assignment_link
    AssignmentUser.create!(user: User.find(user_id), assignment: self)
  end
end
