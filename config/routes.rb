Rails.application.routes.draw do
  devise_for :users
  root to: "topics#home"
<<<<<<< HEAD
=======

  resources :topics
  resources :chats, only: :show do
    resources :messages, only: :create
  end
>>>>>>> 7994d52cdf819687363dbe9253593df146c56e17
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Defines the root path route ("/")
  # root "posts#index"


end
