module Api
  module V1
    class UsersController < ProtectedController
      skip_before_action :authenticate_user, only: [:register, :confirm_email]

      def register
        @user = User.new register_params

        if @user.save
          @user.generate_virify_token
          render @user, status: :created
        else
          render_errors @user.errors
        end
      end

      def confirm_email
        @user = User.confirm_email(params[:token])
        if @user.errors.empty?
          render @user, status: 200
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
