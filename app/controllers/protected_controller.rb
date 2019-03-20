class ProtectedController < ApplicationController
  before_action :authenticate_user

  def unauthorized_entity(_data)
    render_errors I18n.t(:user_unauthorized), status: :unauthorized
  end
end
