require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_secure_password }

  it do
    should validate_presence_of :username
    should validate_uniqueness_of :username
  end

  it { should validate_presence_of :email }

  it { should validate_presence_of :first_name }

  it { should validate_presence_of :last_name }
end
