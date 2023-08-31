Rails.application.routes.draw do
  resources :users
  resources :reservations
  resources :flights
  resources :aircrafts
  get "home/index"  
  root to: "home#index"
end
