module Api
  module V1
    class SolutionsController < BaseController
      before_action :set_solution, only: %i[show update destroy]
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
        @solution = Solution.new(solution_params)

        if @solution.save
          render @solution, status: :created, location: api_v1_solution_url(@solution)
        else
          render_errors @solution.errors
        end
      end

      # PATCH/PUT /solutions/1
      def update
        if @solution.update(solution_params)
          render @solution
        else
          render_errors @solution.errors
        end
      end

      private

      def check_before_create
        assignment = Assignment.find params[:solution][:assignment_id]
        has_proper_role = current_user.has_role? %i[user moderator collaborator], assignment.course
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def set_solution
        @solution = Solution.find_by_id(id)
        render_errors I18n.t(:solution_not_found), status: :not_found if @solution.nil?
      end

      def solution_params
        params.require(:solution).permit(:content, :assignment_id)
        assignment = Assignment.find_by_id(params[:assignment_id])
        render_errors I18n.t(:solution_assignment_not_found), status: :not_found if assignment.nil?
        params.merge(user_id: current_user.id, course_id: assignment.course_id)
      end
    end
  end
end
