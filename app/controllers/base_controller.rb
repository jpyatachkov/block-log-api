class BaseController < ProtectedController
  before_action :set_page_and_size

  protected

  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_PAGE_SIZE = 20

  def paginate(collection)
    items = collection.page(@page).per(@size)
    render json: {total: items.total_pages, items: items }
  end

  def set_page_and_size
    page = params[:page].to_i
    size = params[:size].to_i
    @page = page.zero? ? DEFAULT_PAGE_NUMBER : page
    @size = size.zero? ? DEFAULT_PAGE_SIZE : size
  end
end
