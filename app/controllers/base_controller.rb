class BaseController < ProtectedController 
    before_action :set_page_and_size

    protected

    def set_page_and_size 
        page = params[:page].to_i
        size = params[:size].to_i
        @page = page == 0 ? 1 : page 
        @size = size == 0 ? 20 : size 
        p @page
    end
end 