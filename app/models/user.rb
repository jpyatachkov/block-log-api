class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_secure_password

  def self.from_token_request(request)
    username = request.params['user_token']['username']
    find_by_username username
  end
end
