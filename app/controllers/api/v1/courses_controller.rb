module Api
  module V1
    class CoursesController < BaseController
      before_action :set_course, only: %i[show update destroy enroll set_image]
      before_action :set_course_additional_info, only: %i[show update enroll]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy set_image]

      # if i'm owner + helper or is_visible true
      # GET /courses
      def my_courses(rights)
        current_user.roles.where(resource_type: :Course, name: rights)
                    .where.not(resource_id: nil)
                    .select(:resource_id)
                    .map(&:resource_id)
      end

      def get_extended_course(collection)
        collection
          .joins('LEFT JOIN course_users on courses.id = course_users.course_id')
          .where('course_users.user_id = ?', current_user.id)
          .select('courses.*, course_users.count_passed, course_users.passed')
          # .joins("LEFT JOIN course_users on courses.id = 
          # course_users.course_id and course_users.user_id = #{current_user.id}")
      end

      # it works
      def index
        paginate get_extended_course(Course.where(id: my_courses(%i[moderator collaborator]), is_active: true)
                                         .or(Course.where(is_active: true, is_visible: true))
                                         .distinct)
      end

      def index_mine_inactive
        paginate get_extended_course(Course.where(id: my_courses(%i[moderator collaborator user]), is_active: true))
                      .where('course_users.passed = ?', true), 'api/v1/courses/index'
      end

      def index_mine_active
        paginate get_extended_course(Course.where(id: my_courses(%i[moderator collaborator user]), is_active: true))
                      .where('course_users.passed = ?', false), 'api/v1/courses/index'
      end

      def set_image
        @course.image = params[:image]
        @course.save
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
        params.require(:course).permit(:title, :short_description, :description, :requirements, :complexity)
      end
    end
  end
end
