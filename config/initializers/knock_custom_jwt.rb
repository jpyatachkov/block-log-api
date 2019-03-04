Knock::AuthTokenController.class_eval do
  private

  def auth_params
    params.require(:auth).permit :username, :password
  end
end
