Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'users/new'
  get 'users/create'
  get 'home/index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  post 'signup', to: 'auth#signup'
  post 'signin', to: 'auth#signin'

  # Web routes
  get '/pets', to: 'pets#index', as: :pets
  get '/pets/new', to: 'pets#new', as: :new_pet
  post '/pets', to: 'pets#create'

  # API routes with versioning
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'signup', to: 'auth#signup'
      post 'signin', to: 'auth#signin'
      resources :pets, only: [:create, :index, :show] do
        member do
          patch :mark_expired
        end
      end
    end
  end

  # Defines the root path route ("/")
  root 'home#index'
end
