Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :students
  resources :courses
  resources :units
  resources :enrolments, only: %i[index show new create destroy]
  resources :results, only: %i[index show new create edit update]

  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
