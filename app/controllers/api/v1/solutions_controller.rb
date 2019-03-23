module Api
  module V1
    class SolutionsController < BaseController
      before_action :set_solution, only: %i[show update destroy]
      before_action :check_before_show_delete, only: %i[show destroy]
      before_action :check_before_create, only: :create

      # GET /solutions
      def index
        # we can see solution by u_id and ex_id
        # logic with acess rights implemented in find_all
        paginate Solution.find_all(params[:assignment_id], current_user)
      end

      # GET /solutions/1
      def show
        @solution
      end

      # POST /solutions
      def create
        @solution = Solution.new solution_params_create

        if @solution.save
          render 'api/v1/solutions/show', status: :created, location: api_v1_solution_url(@solution)
        else
          render_errors @solution.errors
        end
      end

      # unused
      # PATCH/PUT /solutions/1
      def update
        if @solution.update solution_params_update
          render 'api/v1/solutions/show'
        else
          render_errors @solution.errors
        end
      end

      private

      def check_before_create
        solution = params.require(:solution).permit(:assignment_id)
        @assignment = Assignment.find_by_id solution[:assignment_id]
        return render_errors I18n.t(:solution_assignment_not_found), status: :not_found if @assignment.nil?

        has_proper_role = current_user.has_role? %i[user moderator collaborator], @assignment.course
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def set_solution
        @solution = Solution.find_by_id(params[:id])
        render_errors I18n.t(:solution_not_found), status: :not_found if @solution.nil?
      end

      def check_before_show_delete
        has_proper_role = current_user.has_role?(%i[moderator collaborator], @solution.course) ||
                          Solution.exists?(id: @solution.id, user_id: current_user.id)

        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      # unused
      def solution_params_update
        params.require(:solution).permit(:content)
      end

      def solution_params_create
        solution = params.require(:solution).permit(:content, :assignment_id)
        solution.merge(user_id: current_user.id, course_id: @assignment.course_id)
      end
    end
  end
end
