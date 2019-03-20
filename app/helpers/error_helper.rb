module ErrorHelper
  class BaseErrorHelper
    attr_accessor :status, :message, :http_status 
  end 

  class UserErrorHelper < BaseErrorHelper
    def initialize(user)
      if user.nil? 
        @status = :not_found
        @message = :user_not_found
      else
        # if user.description[:] = 
      end
    end 

    def self.unauthorized
      @status = 'unauthorized'
      @message = :user_unauthorized
      @http_status = :unauthorized
    end
  end 

  class CourseErrorHelper < BaseErrorHelper
    def initialize(course)
      if course.nil? 
        @status = 'error'
        @message = :course_not_found
        @http_status = :not_found
      else
        # if user.description[:] = 
      end
    end
  end

  class SolutionErrorHelper < BaseErrorHelper
  end

  class AssignmentErrorHelper < BaseErrorHelper
  end

  class CommentaryErrorHelper < BaseErrorHelper
  end
end
