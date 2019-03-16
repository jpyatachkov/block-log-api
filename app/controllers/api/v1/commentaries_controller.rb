module Api
  module V1
    class CommentariesController < BaseController
      before_action :set_commentary, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]
      
      # redefine map maybe
      # rubocop:disable AlignHash
      TABLES_MAP = {
        'course'        =>  Course,
        'assignment'    => Assignment,
        'solution'      => Solution
      }
      # rubocop:enable AlignHash

      # Search by resource, or resource and id
      def index
        resource = TABLES_MAP[params[:resource]]
        resource_id = params[:resource_id]
        paginate Commentary.where(profileable_type: resource, profileable_id: resource_id)
      end

      def show
        @comment
      end

      def update
        # TODO HERE WE CANT MOVE OUR COMMENT TO ANOTHER TABLE
        if @comment.update(commentary_params)
            render @course
          else
            render json: { errors: @comment.errors }, status: :bad_request
          end
      end

      def create
        @comment = Commentary.new(commentary_params).merge(user_id: current_user.id, username: current_user.username)

        if @comment.save
          render @comment, status: :created, location: api_v1_comment_url(@comment)
        else
          render json: { errors: @comment.errors }, status: :bad_request
        end
      end

      private

      # Before create check that user can by course do this
      # user rights for course

      ### 3 entitues ###
      # 1) Course - can write any user of this course
      # 2) Assignment - same strory (user that not enrolled the course, cant it see and doesnt have rights on course)
      # 3) Solution - can see only moderator, collaborator, creator - simplification
      def check_rights_before_create
        has_proper_role = current_user.has_role? :any, Course
        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      # Before update check rights if user - creator
      # Or user is moderator or collaborator
      # Also before delete check the same rights
      # We need to store course id in record solution for this
      # Because rights checks by course id
      def check_rights_before_update_destroy
        has_proper_role = current_user.has_role? %i[moderator collaborator], @course
        
        #check current user created this comment
        has_proper_role = Commentary.find(@comment.id, current_user.id) != nil unless has_proper_role

        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      def set_commentary
        @course = Course.find(params[:id])
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
