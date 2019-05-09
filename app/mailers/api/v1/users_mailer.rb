module Api
  module V1
    class UsersMailer < ActionMailer::Base
      def welcome_email(user, token)
        @user = user
        @token = token
        # ? link may not work
        @link = "#{ENV['SITE_URL']}/api/v1/users/confirm_email/#{@token}"
        mail(:to => @user.email, :subject => "Добро пожаловать")
      end
    end
  end
end
    