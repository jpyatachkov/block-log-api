module Api
  module V1
    class SolutionsController < BaseController
      before_action :set_solution, only: %i[show update destroy]
      before_action :check_before_create, only: :create

      # we can see solution by u_id and ex_id
      # GET /solutions
      def index
        @solutions = Solution.find_all(params[:assignment_id], current_user).page(@page).per(@size)
        render json: @solutions
      end

      # GET /solutions/1
      def show
        render json: @solution
      end

      # POST /solutions
      def create
        @solution = Solution.new(solution_params)

        if @solution.save
          render json: @solution, status: :created, location: api_v1_solution_url(@solution)
        else
          render json: { errors: @solution.errors }, status: :bad_request
        end
      end

      # PATCH/PUT /solutions/1
      def update
        if @solution.update(solution_params)
          render json: @solution
        else
          render json: { errors: @solution.errors }, status: :bad_request
        end
      end

      private

      def check_before_create
        assignment = Assignment.find params[:solution][:assignment_id]
        has_proper_role = current_user.has_role? %i[user moderator collaborator], assignment.course
        render json: { errors: 'You havent been accessed to this course' } unless has_proper_role
      end

      def set_solution
        @solution = Solution.find(id: params[:id])
      end

      def solution_params
        params.require(:solution).permit(:content, :assignment_id).merge user_id: current_user.id
      end
    end
  end
end
