Rails.application.routes.draw do
  resources :membership_users
  resources :memberships
  resources :permissions
  resources :aircraft_users
  resources :users
  resources :hours
  resources :days
  get 'reservations/club', to: 'reservations#club'
  get 'reservations/date/:reservation_date', to: 'reservations#date'
  resources :reservations do
    resources :flights
  end
  resources :flights
  resources :aircrafts
  get "home/index"  
  root to: "home#index"

  get 'login', to: 'sessions#new'
	post 'login', to: 'sessions#create'
	delete 'logout', to: 'sessions#destroy'

  
end
