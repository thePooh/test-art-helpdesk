Rails.application.routes.draw do
  devise_for :users

  resources :tickets do
    member do
      get :assign
      get :hold
      get :complete
      get :cancel
      post :reply
    end
  end

  authenticated :user do
    resources :users

    get 'settings', to: 'users#settings'
    put 'password', to: 'users#password'
    # root to: 'tickets#index'
  end

  root to: 'tickets#new'
end
