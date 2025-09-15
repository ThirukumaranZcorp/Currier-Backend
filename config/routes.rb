Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      devise_for :users,
        path: 'auth',
        defaults: { format: :json },
        controllers: {
          registrations: 'api/v1/registrations',
          sessions: 'api/v1/sessions'
        }

        devise_scope :user do
          post 'auth/send_otp',        to: 'sessions#send_otp'
          post 'auth/verify_otp',      to: 'sessions#verify_otp'
          post 'auth/reset_password',  to: 'sessions#reset_password'
          put  'auth/change_password', to: 'sessions#change_password'
        end
        resources :couriers
        # resources :deliveries, only: [:create]
        resources :deliveries do
          member do
            patch :assign_courier
          end
          resource :delivery_locations, only: [:show, :update]
        end
        resources :courier_recommendations, only: [:index]
    end
  end
  root 'health#index'
  get '/health', to: 'health#index'


end
