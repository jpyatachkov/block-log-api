class BaseController < ProtectedController
  before_action :set_page_and_size

  protected

  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_PAGE_SIZE = 20

  def set_page_and_size
    @page = params[:page].to_i || DEFAULT_PAGE_NUMBER
    @size = params[:size].to_i || DEFAULT_PAGE_SIZE
  end
end
