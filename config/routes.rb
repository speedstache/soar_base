Rails.application.routes.draw do
  resources :aircraft_users
  resources :users
  resources :reservations do
    resources :flights, controller: 'flights'
  end
  resources :flights
  resources :aircrafts
  get "home/index"  
  root to: "home#index"
end
