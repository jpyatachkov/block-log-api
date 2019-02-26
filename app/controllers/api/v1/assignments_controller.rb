module Api
  module V1
    class AssignmentsController < ProtectedController
      before_action :set_assignment, only: %i[show update destroy]

      # GET /assignments
      def index
        @assignments = Assignment.all.where course_id: params[:course_id]
        render json: @assignments
      end

      # GET /assignments/1
      def show
        render json: @assignment
      end

      # POST /assignments
      def create
        @assignment = Assignment.new(assignment_params)

        if @assignment.save
          render json: @assignment,
                 status: :created,
                 location: api_v1_course_assignment_url(@assignment.course, @assignment)
        else
          render json: @assignment.errors, status: :bad_request
        end
      end

      # PATCH/PUT /assignments/1
      def update
        if @assignment.update(assignment_params)
          render json: @assignment
        else
          render json: @assignment.errors, status: :bad_request
        end
      end

      # DELETE /assignments/1
      def destroy
        @assignment.destroy
      end

      private

      def set_assignment
        @assignment = Assignment.find(params[:id])
      end

      def assignment_params
        params.require(:assignment).permit(:text).merge course_id: params[:course_id]
      end
    end
  end
end
