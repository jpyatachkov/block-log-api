Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'ping' => 'ping#ping'

  namespace :api do
    namespace :v1 do
      post 'users/register'
      get 'users/me'
      post 'user_token' => 'user_token#create'
      
      scope 'courses/mine' do 
        get '/active' => 'courses#index_mine_active'
        get '/inactive' => 'courses#index_mine_inactive'
      end
      
      post 'courses/:id/enroll' => 'courses#enroll'

      post 'courses/:id/set_image' => 'courses#set_image'

      resources :courses do
        resources :assignments do
          resources :solutions, only: [:index]
        end
      end

      resources :commentaries, except: [:index]
      get '/commentaries/:profileable_type/:profileable_id' => 'commentaries#index'

      resources :solutions, only: [:create, :show]
    end
  end
end
