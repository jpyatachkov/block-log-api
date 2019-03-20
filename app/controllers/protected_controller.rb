class ProtectedController < ApplicationController
  before_action :authenticate_user

  def unauthorized_entity(data)
    @error = UserErrorHelper.unauthorized
    render '/error', status: @error.http_status
  end 
end
