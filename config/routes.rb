Rails.application.routes.draw do
  devise_for :users
  root to: "topics#home"

  resources :topics do
    member do
      get :start_quiz
      get :show_answer
      post :check_answer
    end
  end

  post "check_answer", to: "chats#check_answer"
  get "show_answer/:topic_id", to: "chats#show_answer", as: :show_answer

  resources :chats, only: [:show, :new, :create] do
    resources :messages, only: :create
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Defines the root path route ("/")
  # root "posts#index"
end
