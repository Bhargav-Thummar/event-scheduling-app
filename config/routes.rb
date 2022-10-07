require 'sidekiq/web'

Rails.application.routes.draw do
  get 'users/show'
  root to: "home#index"

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticated :user do
    root to: "home#dashboard", as: :authenticated_root
  end

  devise_for :users

  resources :booking_types
  resources :bookings, except: [:index, :new]

  get ":booking_link", to: "users#show", as: :user

  scope '/:booking_link', as: :user do
    resources :bookings, only: [:index, :new]
  end
end