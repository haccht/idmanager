Rails.application.routes.draw do
  root "users#index"

  resources :users do
    member do
      get 'password', action: 'edit_password'
      put 'password', action: 'update_password'
    end
  end
  resources :groups

  passwordless_for :sessions
end
