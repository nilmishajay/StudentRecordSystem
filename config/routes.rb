Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :students
  resources :courses
  resources :units
  resources :results

  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
