require 'rails_helper'

RSpec.describe Solution, type: :model do
  it { should validate_presence_of :content }

  it { should belong_to :assignment }
end
