Rails.application.routes.draw do
  get 'ping' => 'ping#ping'

  namespace :api do
    namespace :v1 do
      post 'users/register'
      post 'user_token' => 'user_token#create'

      resources :courses
    end
  end
end
