module Api
  module V1
    class AssignmentsController < BaseController
      before_action :set_assignment, only: %i[show update destroy]
      before_action :check_course_main, only: %i[creata index]
      before_action :check_rights_before_create_update, only: %i[create update]
      before_action :check_rights_before_destroy, only: %i[destroy]

      # GET /assignments
      def index
        paginate Assignment.all.where(course_id: params[:course_id], is_active: true)
      end

      # GET /assignments/1
      def show
        @assignment
      end

      # POST /assignments
      def create
        @assignment = Assignment.new(assignment_params)

        if @assignment.save
          render 'api/v1/assignments/show',
                 status: :created,
                 location: api_v1_course_assignment_url(@assignment.course, @assignment)
        else
          render_errors @assignment.errors
        end
      end

      # PATCH/PUT /assignments/1
      def update
        if @assignment.update(assignment_params)
          render 'api/v1/assignments/show'
        else
          render_errors @assignment.errors
        end
      end

      # DELETE /assignments/1
      def destroy
        @assignment.destroy
      end

      private

      def check_course_main
        course = Course.find_by_id(params[:course_id])
        render_errors I18n.t(:course_not_found), status: :not_found unless course.visible(current_user)
      end

      def check_rights_before_create_update
        has_proper_role = current_user.has_role? %i[moderator collaborator], Course.find(params[:course_id])
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def check_rights_before_destroy
        has_proper_role = current_user.has_role? :moderator, @assignment.course
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def set_assignment
        @assignment = Assignment.find_by_id(params[:id])
        render_errors I18n.t(:assignment_not_found), status: :not_found if @assignment.nil? || !@assignment.is_active ||
                                                                           !@assignment.course.visible(current_user)
      end

      def assignment_params
        params.require(:assignment).permit(
          :title,
          :description,
          :program,
          tests: {
            inputs: [],
            outputs: []
          }
        ).merge(course_id: params[:course_id], user_id: current_user.id)
      end
    end
  end
end
