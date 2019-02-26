require 'rails_helper'

RSpec.describe Course, type: :model do
  it do
    should validate_presence_of :title
    should validate_uniqueness_of :title
  end

  it { should validate_presence_of :description }
end
