class ApplicationController < ActionController::API
  before_action :set_locale

  include Knock::Authenticable
  include ErrorHelper

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
