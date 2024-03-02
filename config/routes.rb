Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "/foods/show_lazy/",to: "foods#show_lazy"

  resources :foods, only: ['index', 'show', 'new', "create", "update", "edit"]


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
