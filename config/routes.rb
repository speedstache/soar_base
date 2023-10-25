Rails.application.routes.draw do
  resources :field_status_updates
  resources :towfees
  resources :membership_users
  resources :memberships,     except: [:destroy]
  resources :permissions,     except: [:destroy]
  resources :aircraft_users
  resources :users,     except: [:destroy]
  resources :hours,     except: [:destroy]
  resources :days,     except: [:destroy]
  get 'reservations/club', to: 'reservations#club'
  resources :reservations do
    resources :flights
  end
  resources :flights
  resources :aircrafts,     except: [:destroy]
  
  get "home/index"  
  root to: "pages#index"

  get "pages/index", to: 'pages#index'

  resources :profile, only: [:index, :edit, :update]
  resources :members, only: [:index]

  get 'login', to: 'sessions#new'
	post 'login', to: 'sessions#create'
	delete 'logout', to: 'sessions#destroy'

  get 'checkout', to: 'checkouts#show'
  get 'checkout/success', to: 'checkouts#success'
  get 'checkout/failure', to: 'checkouts#failure'
  get 'billing', to: 'billing#show'

  namespace :webhooks do
    resource :reservation, controller: :reservation, only: [:create]
    resource :stripe, controller: :stripe, only: [:create, :show]
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
end
