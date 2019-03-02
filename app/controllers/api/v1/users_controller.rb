module Api
  module V1
    class UsersController < ApplicationController
      def register
        user = User.new register_params

        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors }, status: :bad_request
        end
      end

      # /POST /update_role
      def update_role
        u = User.find(4)
        u.add_role :collaborator, Course.find(14)
      end

      private

      def register_params
        params.require(:user).permit(:username, :password, :password_confirmation, :first_name, :last_name)
      end
    end
  end
end
