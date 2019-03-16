class CommentariesController < BaseController
  before_action :set_commentary, only: %i[show update destroy]
  before_action :check_rights_before_create, only: %i[create]
  before_action :check_rights_before_update_destroy, only: %i[update destroy]

  TABLES_MAP = {
    course: Course.class.name,
    assignment: Assignment.class.name,
    solution: Soulution.class.name
  }

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
    comment = commentary_params
    p comment
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
    comment = params.require(:commentary).permit(:text)
    resource = TABLES_MAP[:params[:resource]]

    render json: { errors: 'Incorrect resource name' }, status: bad_request if resource.nil?

    comment.merge resource
  end
end
