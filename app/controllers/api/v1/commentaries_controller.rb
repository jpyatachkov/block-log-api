module Api
  module V1
    class CommentariesController < BaseController
      before_action :set_commentary, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]
      # redefine map
      # rubocop:disable AlignHash
      TABLES_MAP = {
        'course'        =>  Course,
        'assignment'    => Assignment,
        'solution'      => Solution
      }
      # rubocop:enable AlignHash

      def index
        @comments
      end

      def show
        @comment
      end

      def update
        @comment
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

      ### ??? ###
      def check_rights_before_create
        has_proper_role = current_user.has_role? :moderator, Course
        render json: { errors: 'Not enough rights' }, status: :forbidden unless has_proper_role
      end

      # Before update check rights if user - creator
      # Or user is moderator or collaborator
      # Also before delete check the same rights
      # We need to store course id in record solution for this
      # Because rights checks by course id
      def check_rights_before_update_destroy
        has_proper_role = current_user.has_role? :moderator, @course
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
