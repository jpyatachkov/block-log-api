class ProtectedController < ApplicationController
  before_action :authenticate_user
end
