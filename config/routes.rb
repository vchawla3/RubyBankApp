Rails.application.routes.draw do
  resources :transactions
  resources :accounts
  resources :friends
  resources :people
  resources :admins
  resources :users
  resources :menus
  resources :sessions, only: [:new, :create, :destroy]

  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'


  root "menus#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
