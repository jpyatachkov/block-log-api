module Api
  module V1
    class CommentariesController < BaseController
      before_action :set_commentary, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]

      # THINK HOW REDEFINE MAP IF ITS NEEDED
      # rubocop:disable AlignHash
      TABLES_MAP = {
        'course'        => Course,
        'assignment'    => Assignment,
        'solution'      => Solution
      }.freeze
      # rubocop:enable AlignHash

      # Search by resource, or resource and id
      def index
        resource = TABLES_MAP[params[:resource]]
        resource_id = params[:resource_id]

        render json: { errors: 'Incorrect resource name' }, status: :bad_request if resource.nil?

        # we want to see only acepted comments
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
          render json: { errors: @commentary.errors }, status: :bad_request
        end
      end

      private

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
        has_proper_role = current_user.has_role? %i[moderator collaborator], @commentary.course

        # check current user created this comment
        has_proper_role = Commentary.exists?({ id: @commentary.id, user_id: current_user.id }) unless has_proper_role

        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      def set_commentary
        @commentary = Commentary.find(params[:id])
      end

      # now comment cant refers to another resource
      def commentary_params_update
        params.require(:commentary).permit(:comment)
      end

      def validate_parameters
        p 'hello'
      end 

      # chekc that we have all needed parameters
      # maybe by required
      # if here we send integer raise ex
      def commentary_params_create
        validate_parameters
        comment = params.require(:commentary).permit(:comment)

        comment[:profileable_type] = TABLES_MAP[params[:commentary][:resource]]
        comment[:profileable_id] = params[:commentary][:resource_id]

        if comment[:profileable_type].nil?
          return render json: { errors: 'Incorrect resource name' }, status: :bad_request
        end

        clazz = comment[:profileable_type]
        column = clazz == Course ? :id : :course_id
        course_id = clazz.find(comment[:profileable_id])[column]

        comment.merge course_id: course_id
      end
    end
  end
end
