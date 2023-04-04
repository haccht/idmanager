Rails.application.routes.draw do
  root "users#index"
  passwordless_for :auth

  resources :users do
    member do
      get   "password", action: "edit_password"
      put   "password", action: "update_password"
      patch "password", action: "update_password"
    end
  end
  resources :groups
end
