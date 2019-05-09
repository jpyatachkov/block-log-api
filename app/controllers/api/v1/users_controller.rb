module Api
  module V1
    class UsersController < ProtectedController
      skip_before_action :authenticate_user, only: [:register, :confirm_email]

      def register
        @user = User.new register_params

        if @user.save
          token = @user.generate_virify_token
          # p url_for(controller: 'users', action: 'confirm_email', only_path: false, token: token)
          UsersMailer.welcome_email(@user, token).deliver_later
          render @user, status: :created
        else
          render_errors @user.errors
        end
      end

      def confirm_email
        @user = User.confirm_email(params[:token])
        # todo generate another path for frontend
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
