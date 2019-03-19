module Api
  module V1
    class UsersController < ApplicationController
      # conflct
      def register
        user = User.new register_params

        if user.save
          render user, status: :created
        else
          @error UserError.new(user)
          render '/error', status: @error.http_status
          # render json: { errors: user.errors }, status: :bad_request
        end
      end

      private

      # bad_request some fields empty  
      def register_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :first_name, :last_name)
      end
    end
  end
end
