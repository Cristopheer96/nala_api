Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get 'users', to: 'users#list'
      resources :leave_requests, only: [] do
        collection do
          post :import
          get :analytics
          get :healthcheck
          get :index
          post :create
        end
        member do
          put :update
          delete :destroy
        end
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
