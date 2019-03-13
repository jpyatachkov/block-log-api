class BaseController < ProtectedController
  before_action :set_page_and_size

  protected

  def set_page_and_size
    page = params[:page].to_i
    size = params[:size].to_i
    @page = page.zero? ? 1 : page
    @size = size.zero? ? 20 : size
  end
end
