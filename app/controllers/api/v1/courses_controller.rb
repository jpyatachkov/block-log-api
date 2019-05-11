module Api
  module V1
    class CoursesController < BaseController
      before_action :set_course, only: %i[show update destroy enroll]
      before_action :set_course_additional_info, only: %i[show update enroll]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]

      # GET /courses
      def index
        paginate Course.all_visible_to current_user
      end

      # GET /courses/mine/inactive
      def index_mine_inactive
        paginate Course.all_belongs_to(current_user, true), 'api/v1/courses/index'
      end

      # GET /courses/mine/active
      def index_mine_active
        paginate Course.all_belongs_to(current_user, false), 'api/v1/courses/index'
      end

      # GET /courses/1
      def show
        @user_roles = current_user.roles
                          .select(:name)
                          .where(resource_type: :Course, resource_id: @course.id)
                          .map(&:name)
        @user_roles = nil if @user_roles.empty?
        @course
      end

      # POST /courses
      def create
        @course = Course.new(course_params.merge(user_id: current_user.id))
        if @course.save
          @course_additional_info = @course.course_users.where(user_id: current_user.id).first
          render 'api/v1/courses/show', status: :created, location: api_v1_course_url(@course)
        else
          render_errors @course.errors
        end
      end

      # PATCH/PUT /courses/1
      def update
        if @course.update(course_params)
          render 'api/v1/courses/show'
        else
          render_errors @course.errors
        end
      end

      # DELETE /courses/1
      def destroy
        @course.destroy
      end

      # POST /course/1/enroll
      def enroll
        course_user = CourseUser.new(course_id: @course.id, user_id: current_user.id)

        if course_user.save
          render json: course_user
        else
          render_errors course_user.errors, status: :conflict
        end
      end

      private

      def check_rights_before_create
        has_proper_role = current_user.has_role? :moderator, Course
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def check_rights_before_update_destroy
        has_proper_role = current_user.has_role? :moderator, @course
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def set_course
        @course = Course.find_by_id(params[:id])
        render_errors I18n.t(:course_not_found), status: :not_found if @course.nil? || !@course.is_active ||
            !@course.visible(current_user)
      end

      def set_course_additional_info
        @course_additional_info = @course.course_users.where(user_id: current_user.id).first
        if @course_additional_info.nil?
          @course_additional_info = CourseUser.new
        end
      end

      def course_params
        params.require(:course).permit :title,
                                       :short_description,
                                       :description,
                                       :requirements,
                                       :complexity,
                                       :avatar_base64
      end
    end
  end
end
