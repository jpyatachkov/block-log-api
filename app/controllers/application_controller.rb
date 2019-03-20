class ApplicationController < ActionController::API
  include Knock::Authenticable
  include ErrorHelper
end
