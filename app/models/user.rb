class User < ApplicationRecord
  rolify strict: true

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  after_create :assign_default_role,
               :process_is_staff_flag
  after_update :process_is_staff_flag

  def self.from_token_request(request)
    find_by_username request.params.dig 'auth', 'username'
  end

  def to_token_payload
    main_roles = roles.select(:name)
                      .where(resource_type: :Course)
                      .map(&:name)
                      .uniq
                      .reject { |role| role == 'collaborator' }
    { sub: id, role: main_roles, is_confirmed: is_confirmed }
  end

  protected

  def assign_default_role
    add_role(:user, Course) if roles.blank?
  end

  def process_is_staff_flag
    if is_staff
      add_role :moderator, Course
    else
      remove_role :moderator, Course
    end
  end
end
