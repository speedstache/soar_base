require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require 'admin_constraint'

Rails.application.routes.draw do

  resources :field_status_updates
  resources :email_requests
  
  resources :towfees
  resources :membership_users
  resources :memberships,     except: [:destroy]
  resources :permissions,     except: [:show, :destroy]
  resources :aircraft_users
  get 'users/archived', to: 'users#archived_index', as: 'archived_users'

  resources :users,     except: [:destroy]
  get 'users/:sendme/resend', to: 'users#resend', as: 'resend_user'



  resources :hours,     except: [:destroy]
  resources :days,     except: [:destroy]
  get 'reservations/club', to: 'reservations#club', as: 'reservations_club'
  get 'reservations/tow', to: 'reservations#tow_index', as: 'reservations_tow'
  get 'reservations/cfi', to: 'reservations#cfi_index', as: 'reservations_cfi'
  get 'reservations/comm', to: 'reservations#comm_index', as: 'reservations_comm'

  match 'reservations/tow/:id/update', to: 'reservations#tow_update', as: 'update_reservations_tow', via: [:get, :post]
  match 'reservations/cfi/:id/update', to: 'reservations#cfi_update', as: 'update_reservations_cfi', via: [:get, :post]
  match 'reservations/comm/:id/update', to: 'reservations#comm_update', as: 'update_reservations_comm', via: [:get, :post]


  resources :reservations do
    resources :flights
    resources :tows
  end

  resources :tows

  resources :flights
  resources :aircrafts,     except: [:destroy]
  
  get "home/index", to: "home#index"
  get "home/how_to", to: "home#how_to", as: 'how_to'
  get "home/club_docs", to: "home#club_docs", as: 'club_docs'


  root to: "pages#index"

  get "pages/index", to: 'pages#index'
  get 'pages/flights', to: 'pages#flights', as: 'pages_flights'   
  get 'pages/instruction', to: 'pages#instruction'
  get 'pages/membership', to: 'pages#membership'


  get 'admin/reservations', to: 'admin#reservations'
  match 'admin/reservations/:id/edit', to: 'admin#editreservation', as: 'edit_admin_reservation', via: [:get, :post]
  match 'admin/reservations/:id/edit', to: 'admin#updatereservation', as: 'update_admin_reservation', via: [:post, :put, :patch]
  match 'admin/reservations/:id/delete', to: 'reservations#destroy', as: 'delete_admin_reservation', via: :delete

  get 'admin/flights', to: 'admin#flights'
  match 'admin/flights/:id/edit', to: 'admin#editflight', as: 'edit_admin_flight', via: [:get, :post, :put, :patch]
  
  get 'admin/instructors', to: 'admin#instructors'
  match 'admin/instructors/:id/edit', to: 'admin#editinstructor', as: 'edit_admin_instructor', via: [:get, :post, :put, :patch]


  get 'admin/emails', to: 'admin#emails', as: 'admin_emails'
  match 'email_requests/:id/update', to: 'email_requests#update', as: 'update_email_request', via: [:get, :post]
  get 'forward_email', to: 'email_requests#forward_email', as: :forward_email
  get 'trello_ride_request', to: 'email_requests#trello_ride_request', as: :trello_ride_request
  get 'trello_membership_request', to: 'email_requests#trello_membership_request', as: :trello_membership_request


  get 'admin/aircrafts', to: 'admin#aircrafts'
  get 'admin/towpilots', to: 'admin#towpilots'


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

  mount Sidekiq::Web => "/sidekiq", :constraints => AdminConstraint.new

end
