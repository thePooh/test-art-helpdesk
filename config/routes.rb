Rails.application.routes.draw do
  devise_for :users

  resources :tickets

  authenticated :user do
    # root to: 'tickets#index'
  end

  root to: 'tickets#new'
end
