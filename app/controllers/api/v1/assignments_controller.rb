module Api
  module V1
    class AssignmentsController < BaseController
      before_action :set_assignment, only: %i[show update destroy]
      before_action :check_rights_before_create_update, only: %i[create update]
      before_action :check_rights_before_destroy, only: %i[destroy]

      # GET /assignments
      def index
        paginate Assignment.all.where(course_id: params[:course_id])
      end

      # GET /assignments/1
      def show
        @assignment
      end

      # POST /assignments
      def create
        @assignment = Assignment.new(assignment_params)

        if @assignment.save
          render @assignment,
                 status: :created,
                 location: api_v1_course_assignment_url(@assignment.course, @assignment)
        else
          render json: { errors: @assignment.errors }, status: :bad_request
        end
      end

      # PATCH/PUT /assignments/1
      def update
        if @assignment.update(assignment_params)
          render @assignment
        else
          render json: { errors: @assignment.errors }, status: :bad_request
        end
      end

      # DELETE /assignments/1
      def destroy
        @assignment.destroy
      end

      private

      def check_rights_before_create_update
        has_proper_roles = current_user.has_role? %i[moderator collaborator], Course.find(params[:course_id])
        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_roles
      end

      def check_rights_before_destroy
        has_proper_role = current_user.has_role? :moderator, @assignment.course
        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      def set_assignment
        @assignment = Assignment.find(params[:id])
      end

      def assignment_params
        params.require(:assignment).permit(
          :text,
          tests: {
            inputs: [],
            outputs: []
          }
        ).merge(course_id: params[:course_id], user_id: current_user.id)
      end
    end
  end
end
