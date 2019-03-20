module Api
  module V1
    class CommentariesController < BaseController
      before_action :set_profirable, only: %i[index]
      before_action :set_commentary, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]

      # WE STAORE course_id for check user rights
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

      # GET /commentaries
      # Search commentarie by resource and maybe resourse_id
      def index
        # resource = TABLES_MAP[params[:resource].to_sym]
        # resource_id = params[:resource_id]

        # render json: { errors: 'Incorrect resource name' }, status: :bad_request if resource.nil?

        # is_active - to get only alive comments
        # query_hash)
        # query_hash = { profileable_type: resource.name, is_active: true }
        # query_hash[:profileable_id] = resource_id unless resource_id.nil?

        paginate Commentary.all.where(profileable_type: @profirable, profileable_id: @profileable_id, is_active: true)
      end

      def show
        @commentary
      end

      def update
        # HERE WE CANT MOVE OUR COMMENT TO ANOTHER TABLE
        if @commentary.update(commentary_params_update)
          render @commentary
        else
          render_errors @commentary.errors
        end
      end

      def destroy
        @commentary.destroy
      end

      # SEND CUSTOM READING MESSAGE 404 NOT FOUND ASSOCIATED ENTITY
      def create
        # check that associated entity
        @commentary = Commentary.new commentary_params_create.merge user_id: current_user.id,
                                                                    username: current_user.username

        if @commentary.save
          render @commentary, status: :created, location: api_v1_commentary_url(@commentary)
        else
          render_errors @commentary.errors
        end
      end

      private

      # index, show uses this
      def set_profirable
        @profileable_id = params[:resource_id]
        @profirable = case params[:resource]
                      when 'course'
                        Course
                      when 'assignment'
                        Assignment
                      when 'solution'
                        Solution
                      end

        return render_errors I18n.t(:profirable_not_set) if @profirable.nil?
        return render_errors I18n.t(:profirable_id_not_set) if @profirable_id.nil?
      end

      # Before create check that user can by course do this
      # user rights for course

      #################################################################################################
      # 1) Course - can write any user of this course
      # 2) Assignment - same strory (user that not enrolled the course, cant it see and doesnt have rights on course)
      # 3) Solution - can see only moderator, collaborator, creator - simplification
      def check_rights_before_create
        has_proper_role = current_user.has_role? %i[moderator collaborator user], Course
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      # Before update check rights if user - creator
      # Or user is moderator or collaborator
      # Also before delete check the same rights
      # We need to store course id in record solution for this
      # Because rights checks by course id
      def check_rights_before_update_destroy
        has_proper_role = current_user.has_role?(%i[moderator collaborator], @commentary.course) ||
            Commentary.exists?(id: @commentary.id, user_id: current_user.id)

        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def set_commentary
        @commentary = Commentary.find_by_id(params[:id])
        render_errors I18n.t(:commentary_not_found), status: :not_found if @commentary.nil?
      end

      def commentary_params_update
        # now comment cant refers to another resource
        params.require(:commentary).permit(:comment)
      end

      # Check that we have all needed parameters
      # maybe by required
      # if here we send integer raise ex
      def commentary_params_create
        comment = params.require(:commentary).permit(:comment, :profileable_type, :profileable_id)

        set_profirable

        column = @profirable == Course ? :id : :course_id
        course_id = @profirable.find(@profileable_id)[column]

        comment.merge(course_id: course_id, profileable_type: @profirable)
      end
    end
  end
end
