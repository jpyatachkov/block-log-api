class BaseController < ProtectedController
  before_action :set_pagination_params
  before_action :check_user_confimed

  protected

  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_PAGE_SIZE = 20

  def paginate(collection, view = nil)
    @items = collection.order(@order).page(@page).per(@size)
    @total_pages = @items.total_pages
    return render view unless view.nil?
  end

  def set_pagination_params
    page = params[:page].to_i
    size = params[:size].to_i
    @order = { created_at: :desc }
    @page = page.zero? ? DEFAULT_PAGE_NUMBER : page
    @size = size.zero? ? DEFAULT_PAGE_SIZE : size
  end

  def check_user_confimed
    render_errors I18n.t(:not_confirmed), status: :forbidden unless current_user.is_confirmed
  end
end
