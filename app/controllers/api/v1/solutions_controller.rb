module Api
  module V1
    class SolutionsController < ProtectedController
      before_action :set_solution, only: %i[show update destroy]

      # GET /solutions
      def index
        @solutions = Solution.all.where assignment_id: params[:assignment_id]
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

      # DELETE /solutions/1
      def destroy
        @solution.destroy
      end

      private

      def set_solution
        @solution = Solution.find(params[:id])
      end

      def solution_params
        params.require(:solution).permit(:content, :assignment_id)
      end
    end
  end
end
