Rails.application.routes.draw do
  devise_for :users
  resources :transactions
  resources :accounts
  resources :friends
  resources :people
  resources :admins
  resources :menus

  root "admins#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
