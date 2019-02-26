require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it { should validate_presence_of :text }

  it { should belong_to :course }
end
