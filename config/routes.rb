Rails.application.routes.draw do

  resources :field_status_updates
  resources :towfees
  resources :membership_users
  resources :memberships,     except: [:destroy]
  resources :permissions,     except: [:show, :destroy]
  resources :aircraft_users
  resources :users,     except: [:destroy]
  get 'users/:sendme/resend', to: 'users#resend', as: 'resend_user'


  resources :hours,     except: [:destroy]
  resources :days,     except: [:destroy]
  get 'reservations/club', to: 'reservations#club', as: 'reservations_club'
  get 'reservations/tow', to: 'reservations#tow_index', as: 'reservations_tow'
  match 'reservations/tow/:id/update', to: 'reservations#tow_update', as: 'update_reservations_tow', via: [:get, :post]


  resources :reservations do
    resources :flights
    resources :tows
  end

  resources :tows

  resources :flights
  resources :aircrafts,     except: [:destroy]
  
  get "home/index", to: "home#index"
  get "home/how_to", to: "home#how_to", as: 'how_to'
  root to: "pages#index"

  get "pages/index", to: 'pages#index'

  get 'admin/reservations', to: 'admin#reservations'
  match 'admin/reservations/:id/edit', to: 'admin#edit', as: 'edit_admin_reservation', via: [:get, :post]

  get 'admin/aircrafts', to: 'admin#aircrafts'
  get 'admin/instructors', to: 'admin#instructors'


  resources :profile, only: [:index, :show, :edit, :update]
  resources :members, only: [:index]

  get 'login', to: 'sessions#new'
	post 'login', to: 'sessions#create'
	delete 'logout', to: 'sessions#destroy'

  get 'checkout', to: 'checkouts#show'
  get 'checkout/success', to: 'checkouts#success'
  get 'checkout/failure', to: 'checkouts#failure'
  match 'checkout/:id/update', to: 'checkouts#update', via: [:patch, :put]
  match 'checkout/:id/edit', to: 'checkouts#edit', as: 'edit_checkout', via: [:get, :post]
  get 'checkout/pending_success', to: 'checkouts#pending_success'
  get 'billing', to: 'billing#show'

  namespace :webhooks do
    resource :reservation, controller: :reservation, only: [:create]
    resource :stripe, controller: :stripe, only: [:create, :show]
  end

  resources :account_activations, only: [:edit]
 
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
end
