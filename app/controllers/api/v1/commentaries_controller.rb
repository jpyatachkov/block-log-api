module Api
  module V1
    class CommentariesController < BaseController
      before_action :set_profirable, :only %i[create]
      before_action :set_commentary, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]

      ############################################
      ############ ERRORS ########################
      ############################################
      ### 1) NOT FOUND ASSOCIATED ENTITY - {status: "Not found":
      ###     ErrorMessage: "Associated entity not found"} :state :not_found
      ### 2) NOT FOUND ENTITY - {status: "Not found": ErrorMessage: "Entity"}
      ### 3) UNAUTHORIZED - RENDERED BY kaminari
      ### 4) FORBIDDEN - {status: "Forbidden", ErrorMessage: "You haven't got enough rights"}
      ### 5) BAD_REQUEST - {status: "Field incorrect", "Field empty"} ...
      #############################################

      TABLES_MAP = {
        course: Course,
        assignment: Assignment,
        solution: Solution
      }.freeze

      # ALSO WE NEED TO CHECK HOW TO CONVERT to_sym

      # GET /commentaries
      # Search commentarie by resource and maybe resourse_id
      def index
        resource = TABLES_MAP[params[:resource].to_sym]
        resource_id = params[:resource_id]

        render json: { errors: 'Incorrect resource name' }, status: :bad_request if resource.nil?

        # is_active - to get only alive comments
        query_hash = { profileable_type: resource.name, is_active: true }
        query_hash[:profileable_id] = resource_id unless resource_id.nil?

        paginate Commentary.all.where(query_hash)
      end

      def show
        @commentary
      end

      ##################################################################
      ### CHECK THAT UDPATE NOT MOVED COMMENT TO ANOTHER TABLE #########
      ##################################################################
      def update
        # HERE WE CANT MOVE OUR COMMENT TO ANOTHER TABLE
        if @commentary.update(commentary_params_update)
          render @commentary
        else
          ### render error for 404, 500 - database crush
          render json: { errors: @commentary.errors }, status: :bad_request
        end
      end

      def destroy
        @commentary.destroy
      end

      # SEND CUSTOM READING MESSAGE 404 NOT FOUND ASSOCIATED ENTITY
      def create
        # check that associated entity
        @commentary = Commentary.new commentary_params_create
                      .merge(user_id: current_user.id, username: current_user.username)

        if @commentary.save
          render @commentary, status: :created, location: api_v1_commentary_url(@commentary)
        else
          ### render error for 404, 500 - database crush
          render json: { errors: @commentary.errors }, status: :bad_request
        end
      end

      private

      # index, show uses this
      def set_profirable
        @profirable = case 
          when 'course': Course
          when 'assignment': Assignment
          when 'solution': Solution
          else nil
        end
      end

      # Before create check that user can by course do this
      # user rights for course

      #################################################################################################
      # 1) Course - can write any user of this course
      # 2) Assignment - same strory (user that not enrolled the course, cant it see and doesnt have rights on course)
      # 3) Solution - can see only moderator, collaborator, creator - simplification
      def check_rights_before_create
        has_proper_role = current_user.has_role? %i[moderator collaborator user], Course
        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      # Before update check rights if user - creator
      # Or user is moderator or collaborator
      # Also before delete check the same rights
      # We need to store course id in record solution for this
      # Because rights checks by course id
      def check_rights_before_update_destroy
        has_proper_role = current_user.has_role?(%i[moderator collaborator], @commentary.course) ||
                          Commentary.exists?(id: @commentary.id, user_id: current_user.id)

        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      def set_commentary
        # return render json: {hello: I18n.t(:hello)}
        @commentary = Commentary.find_by_id(params[:id])
        # return render 
      end

      # now comment cant refers to another resource
      def commentary_params_update
        params.require(:commentary).permit(:comment)
      end

      # chekc that we have all needed parameters
      # maybe by required
      # if here we send integer raise ex
      def commentary_params_create
        # return render 
        comment = params.require(:commentary).permit(:comment, :resource, :resource_id)

        resource_class = TABLES_MAP[params[:commentary][:resource].to_sym]
        resource_id = params[:commentary][:resource_id]

        return render json: { errors: 'Incorrect resource name' }, status: :bad_request if resource_class.nil?
        return render json: { errors: 'Incorrect resource id' }, status: :bad_request if resource_id.nil?

        column = resource_class == Course ? :id : :course_id
        course_id = resource_class.find(resource_id)[column]

        comment.merge(course_id: course_id, profileable_type: resource_class, profileable_id: resource_id)
      end
    end
  end
end
