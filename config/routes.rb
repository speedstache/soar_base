Rails.application.routes.draw do
  resources :membership_users
  resources :memberships
  resources :permissions
  resources :aircraft_users
  resources :users
  resources :hours
  resources :reservations do
    resources :flights, controller: 'flights'
  end
  resources :flights
  resources :aircrafts
  get "home/index"  
  root to: "home#index"

  get 'login', to: 'sessions#new'
	post 'login', to: 'sessions#create'
	delete 'logout', to: 'sessions#destroy'
end
