module Api
  module V1
    class CoursesController < ProtectedController
      before_action :set_course, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]

      # GET /courses
      def index
        @courses = Course.all
        render json: @courses
      end

      # GET /courses/1
      def show
        render json: @course
      end

      # POST /courses
      def create
        @course = Course.new(course_params.merge user_id: current_user.id)

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

      private

      def check_rights_before_create
        unless current_user.has_role? :moderator, Course
          return render json: {errors: "Not enough rights"}, status: :forbidden
        end
      end

      def check_rights_before_update_destroy
        course_id = params[:id]
        unless current_user.has_role? :moderator, Course.find(course_id)
          p 'here'
          return render json: {errors: "Not enough rights"}, status: :forbidden 
        end
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