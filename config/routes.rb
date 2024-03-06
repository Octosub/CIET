Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: "pages#home"

  get "/scan", to: "pages#scan", as: :scan

  resources :foods, only: ['index', 'show', 'new', "create", "update", "edit"] do
    resources :favorites, only: ['create']
  end
  resources :favorites, only: ['destroy']
  
  # resources :users, only: ['edit', 'update']

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
