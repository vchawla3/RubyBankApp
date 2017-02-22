Rails.application.routes.draw do
  resources :account_requests
  devise_for :users, :path => 'u'
  resources :users
  resources :transactions
  resources :accounts
  resources :friends
  resources :admins

  devise_scope :user do
    authenticated :user do
      root 'admins#index'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
