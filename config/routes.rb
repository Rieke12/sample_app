Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get     'sessions/new'
  root    'static_pages#home'
  get     '/signup',  to: 'users#new'
  post    '/signup',  to: 'users#create'
  get     '/help',    to: 'static_pages#help'
  get     '/about',   to: 'static_pages#about'
  get     '/contact', to: 'static_pages#contact'
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'
  resources :users
  # creates a named routde for account activations
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  #doesn't need new and edit, as those are handled through user profile
  resources :microposts,          only: [:create, :destroy]
end
