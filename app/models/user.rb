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

  # think that he can get token, but he cant do anything without confirmation
  # also if he send incorrect email we need to change it and get new email
  def self.from_token_request(request)
    find_by_username request.params.dig 'auth', 'username'
    # find_by(username: request.params.dig('auth', 'username'), is_confirmed: true)
  end

  def to_token_payload
    main_roles = roles.select(:name)
                      .where(resource_type: :Course)
                      .map(&:name)
                      .uniq
                      .reject { |role| role == 'collaborator' }
    { sub: id, role: main_roles }
  end

  def generate_virify_token
    token = SecureRandom.urlsafe_base64.to_s
    $redis.set(token, id)
    token
  end

  def self.confirm_email(token) 
    id = $redis.get(token)
    user = User.find_by_id(id)
    return generate_error_user(:id, I18n.t(:not_found)) if user.nil?

    user.is_confirmed = true
    user.save!
    $redis.del(token)
    # maybe need to check exceptions
    user
  end

  protected

  def self.generate_error_user(key, val)
    user = User.new
    user.errors.add(key, val)
    user
  end

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
