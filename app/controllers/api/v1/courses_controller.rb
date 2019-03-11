module Api
  module V1
    class CoursesController < BaseController
      before_action :set_course, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]

      # GET /courses
      def index
        @courses = Course.page(@page).per(@size)
        render json: @courses
      end

      # GET /courses/1
      def show
        render json: @course
      end

      # POST /courses
      def create
        @course = Course.new(course_params.merge(user_id: current_user.id))

        if @course.save
          render json: @course, status: :created, location: api_v1_course_url(@course)
        else
          render json: { errors: @course.errors }, status: :bad_request
        end
      end

      # PATCH/PUT /courses/1
      def update
        if @course.update(course_params)
          render json: @course
        else
          render json: { errors: @course.errors }, status: :bad_request
        end
      end

      # DELETE /courses/1
      def destroy
        @course.destroy
      end

      # POST /course/1/enroll/
      # maybe we need to check if its already exist
      # and if so return 409
      def enroll
        course_user = CourseUser.new(course_id: params[:id], user_id: current_user.id)

        if course_user.save
          render json: course_user
        else
          render json: { errors: course_user.errors }, status: :conflict
        end
      end

      private

      def check_rights_before_create
        has_proper_role = current_user.has_role? :moderator, Course
        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      def check_rights_before_update_destroy
        has_proper_role = current_user.has_role? :moderator, @course
        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      def set_course
        @course = Course.find(params[:id])
      end

      def course_params
        params.require(:course).permit(:title, :description)
      end
    end
  end
end
