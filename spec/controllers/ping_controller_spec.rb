require 'rails_helper'

RSpec.describe PingController, type: :controller do
  it 'should respond with 200 OK' do
    head :ping
    expect(response).to have_http_status :success
  end
end
