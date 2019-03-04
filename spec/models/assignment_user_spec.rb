require 'rails_helper'

RSpec.describe AssignmentUser, type: :model do
  it { should validate_presence_of :user_id }

  it { should validate_presence_of :assignment_id }

  it { should belong_to :user }

  it { should belong_to :assignment }
end
