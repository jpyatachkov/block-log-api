module ErrorHelper
  def render_errors(errors, status: :bad_request)
    @status = status
    @errors = errors
    render '/error', status: status
  end
end
