class BaseController < ProtectedController
  before_action :set_pagination_params

  protected

  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_PAGE_SIZE = 20

  def paginate(collection)
    @items = collection.order(@order).page(@page).per(@size)
    @total_pages = @items.total_pages
  end

  def set_pagination_params
    page = params[:page].to_i
    size = params[:size].to_i
    @order = { created_at: :desc }
    @page = page.zero? ? DEFAULT_PAGE_NUMBER : page
    @size = size.zero? ? DEFAULT_PAGE_SIZE : size
  end
end
