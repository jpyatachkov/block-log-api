module Api
  module V1
    class UsersMailer < ActionMailer::Base
      def welcome_email(user, token)
        @user = user
        @token = token
        mail(to: @user.email, subject: "Добро пожаловать")
      end
    end
  end
end
    