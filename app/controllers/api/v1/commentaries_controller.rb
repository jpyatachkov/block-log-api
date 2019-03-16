module Api
  module V1
    class CommentariesController < BaseController
      before_action :set_commentary, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]

      # THINK HOW REDEFINE MAP IF ITS NEEDED
      # rubocop:disable AlignHash
      TABLES_MAP = {
        'course'        => 'Course',
        'assignment'    => 'Assignment',
        'solution'      => 'Solution'
      }.freeze
      # rubocop:enable AlignHash

      # Search by resource, or resource and id
      def index
        resource = TABLES_MAP[params[:resource]]
        resource_id = params[:resource_id]

        render json: { errors: 'Incorrect resource name' }, status: :bad_request if resource.nil?

        # we want to see only acepted comments
        query_hash = { profileable_type: resource, is_active: true }
        query_hash.merge profileable_id: resource_id unless resource_id.nil?
        paginate Commentary.all.where(query_hash)
      end

      def show
        @commentary
      end

      def update
        # HERE WE CANT MOVE OUR COMMENT TO ANOTHER TABLE
        if @commentary.update(commentary_params)
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
        @commentary = Commentary.new commentary_params.merge(user_id: current_user.id, username: current_user.username)

        if @commentary.save
          render @commentary, status: :created, location: api_v1_commentary_url(@commentary)
        else
          render json: { errors: @commentary.errors }, status: :bad_request
        end
      end

      private

      # Before create check that user can by course do this
      # user rights for course

      ### 3 entities ###
      # 1) Course - can write any user of this course
      # 2) Assignment - same strory (user that not enrolled the course, cant it see and doesnt have rights on course)
      # 3) Solution - can see only moderator, collaborator, creator - simplification
      def check_rights_before_create
        # fix this :any
        has_proper_role = current_user.has_role? %i[moderator collaborator user], Course
        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      # Before update check rights if user - creator
      # Or user is moderator or collaborator
      # Also before delete check the same rights
      # We need to store course id in record solution for this
      # Because rights checks by course id
      def check_rights_before_update_destroy
        has_proper_role = current_user.has_role? %i[moderator collaborator], @course # Is it legal
        # check current user created this comment

        # rubocop:disable Style/OrAssignment
        has_proper_role = Commentary.find(@comment.id, current_user.id).nil? unless has_proper_role
        # rubocop:enable Style/OrAssignment?

        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      def set_commentary
        @commentary = Commentary.find(params[:id])
      end

      def commentary_params
        comment = params.require(:commentary).permit(:comment)

        # chekc that we have all needed parameters
        # maybe by required

        # if here we send integer raise ex
        comment[:profileable_type] = TABLES_MAP[params[:commentary][:resource]]
        comment[:profileable_id] = params[:commentary][:resource_id]

        if comment[:profileable_type].nil?
          return render json: { errors: 'Incorrect resource name' }, status: :bad_request
        end

        comment
      end
    end
  end
end
