Rails.application.routes.draw do
  get 'ping' => 'ping#ping'

  namespace :api do
    namespace :v1 do
      post 'users/register'
      post 'user_token' => 'user_token#create'
      
      #test version
      post 'users/update_role' => 'users#update_role'
      post 'courses/:id/enroll' => 'courses#enroll'
      resources :courses do
        resources :assignments do
          resources :solutions, only: [:index]
        end
      end

      resources :solutions, only: [:create, :show]
    end
  end
end
