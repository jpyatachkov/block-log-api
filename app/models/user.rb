class User < ApplicationRecord
  rolify strict: true

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  after_create :assign_default_role

  def self.from_token_request(request)
    find_by_username request.params.dig 'auth', 'username'
  end

  protected

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
