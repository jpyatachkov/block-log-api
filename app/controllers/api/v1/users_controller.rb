module Api
  module V1
    class UsersController < ProtectedController
      skip_before_action :authenticate_user, only: [:register, :confirm_email]

      def register
        @user = User.new register_params

        if @user.save
          token = generate_token(@user.id, logger)
          if token.nil?
            render_errors I18n.t(:redis_error), status: :internal_server_error
          else
            UsersMailer.welcome_email(@user, token).deliver_later
            render @user, status: :created
          end
        else
          render_errors @user.errors
        end
      end

      def reset_confirm_token
        token = reset_token(current_user.id, logger)
        if token.nil?
          render_errors I18n.t(:redis_error), status: :internal_server_error
        else
          @user = current_user
          UsersMailer.welcome_email(@user, token).deliver_later
          render 'api/v1/users/show', status: :ok
        end
      end

      def confirm_email
        is_error, user_id = find_user_by_token(params[:token], logger).to_a

        if is_error
          return render_errors I18n.t(:redis_error), status: :internal_server_error
        else 
          return render_errors I18n.t(:invalid_token), status: :bad_request if user_id.nil?
        end

        @user = User.find(user_id)
        if @user.update(is_confirmed: true)
          render @user, status: :ok
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
