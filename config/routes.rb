Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users do
        resources :transactions
        collection do
          post 'verification_code' => 'user_token#create'
        end
      end
      resources :user_token, only: [:create]
      post '/verify', to: 'sessions#verify'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
