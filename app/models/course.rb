class Course < ApplicationRecord
  after_create :set_user_permissions

  resourcify
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true

  def set_user_permissions
    user = User.find(user_id)
    user.add_role :moderator, self
  end
end
