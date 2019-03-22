module Api
  module V1
    class UsersController < ProtectedController
      skip_before_action :authenticate_user, only: [:register]

      def register
        @user = User.new register_params

        if @user.save
          render @user, status: :created
        else
          render_errors @user.errors
        end
      end

      def me
        render current_user
      end

      private

      def register_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :first_name, :last_name)
      end
    end
  end
end
