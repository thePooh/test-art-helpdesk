Rails.application.routes.draw do
  devise_for :users

  resources :tickets

  authenticated :user do
    resources :users

    get 'settings', to: 'users#settings'
    put 'password', to: 'users#password'
    # root to: 'tickets#index'
  end

  root to: 'tickets#new'
end
