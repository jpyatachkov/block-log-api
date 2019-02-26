require 'rails_helper'

RSpec.describe ProtectedController, type: :controller do
  it { should use_before_filter(:authenticate_user) }
end
