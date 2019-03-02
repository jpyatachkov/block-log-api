class User < ApplicationRecord
  rolify strict: true

  after_create :assign_default_role

  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_secure_password

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def self.from_token_request(request)
    username = request.params['auth']['username']
    find_by_username username
  end
end
