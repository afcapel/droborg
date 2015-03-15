Droborg::Application.routes.draw do

  resources :users

  resources :projects do
    put :refresh, on: :member
    resources :builds
  end

  namespace :deploy do
    resources :environments
  end

  resources :tasks do
    put :move, on: :member
  end

  resources :builds
  resources :deploys
  resources :jobs
  resources :results



  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  resource :session
  get "auth/github/callback", to: "sessions#create"

  root 'projects#index'
end
