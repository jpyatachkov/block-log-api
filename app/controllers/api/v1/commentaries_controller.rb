module Api
  module V1
    class CommentariesController < BaseController
      before_action :set_profileable_index, only: %i[index]
      before_action :set_profileable_create, only: %i[create]
      before_action :set_commentary, only: %i[show update destroy]
      before_action :check_rights_before_create, only: %i[create]
      before_action :check_rights_before_update_destroy, only: %i[update destroy]

      # GET /commentaries
      # Search commentarie by resource and maybe resourse_id
      def index
        paginate Commentary.all.where(profileable_type: @profileable_type.name,
                                      profileable_id: @profileable_id,
                                      is_active: true)
      end

      def show
        @commentary
      end

      def create
        # check that associated entity
        @commentary = Commentary.new commentary_params_create.merge user_id: current_user.id,
                                                                    username: current_user.username

        if @commentary.save
          render 'api/v1/commentaries/show', status: :created, location: api_v1_commentary_url(@commentary)
        else
          render_errors @commentary.errors
        end
      end

      def update
        # HERE WE CANT MOVE OUR COMMENT TO ANOTHER TABLE
        if @commentary.update(commentary_params_update)
          render 'api/v1/commentaries/show'
        else
          render_errors @commentary.errors
        end
      end

      def destroy
        @commentary.destroy
      end

      private

      def check_rights_before_create
        has_proper_role = current_user.has_role? %i[moderator collaborator user], Course
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def check_rights_before_update_destroy
        has_proper_role = current_user.has_role?(%i[moderator collaborator], @commentary.course) ||
                          Commentary.exists?(id: @commentary.id, user_id: current_user.id)
        render_errors I18n.t(:unsufficient_rights), status: :forbidden unless has_proper_role
      end

      def resolve_profileable_type
        case hash['profileable_type']
        when 'course'
          Course
        when 'assignment'
          Assignment
        when 'solution'
          Solution
        end
      end

      def search_profileable(hash)
        @profileable_id = hash['profileable_id']
        @profileable_type = resolve_profileable_type

        # crutch for before action
        if @profileable_type.nil?
          @error = I18n.t(:profileable_type_not_set)
        elsif @profileable_id.nil?
          @error = I18n.t(:profileable_id_not_set) if @profileable_id.nil?
        end
      end

      def set_profileable_index
        search_profileable params
        render_errors @error unless @error.nil?
      end

      def set_profileable_create
        comment = params.require(:commentary).permit(:profileable_type, :profileable_id)

        search_profileable comment

        render_errors @error unless @error.nil?
      end

      def set_commentary
        @commentary = Commentary.find_by_id(params[:id])
        render_errors I18n.t(:commentary_not_found), status: :not_found if @commentary.nil?
      end

      def commentary_params_update
        params.require(:commentary).permit(:comment)
      end

      def commentary_params_create
        comment = params.require(:commentary).permit(:comment)

        column = @profileable_type == Course ? :id : :course_id
        course_id = @profileable_type.find(@profileable_id)[column]

        comment.merge course_id: course_id,
                      profileable_type: @profileable_type,
                      profileable_id: @profileable_id
      end
    end
  end
end
