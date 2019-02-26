Knock::AuthTokenController.class_eval do
  private
  def auth_params
    params.require(:user_token).permit :username, :password
  end
end
