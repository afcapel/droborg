Droborg::Application.routes.draw do

  resources :users

  resources :projects do
    resources :tasks
    resources :builds
  end

  resources :builds
  resources :deploys
  resources :jobs
  resources :results


  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  resource :session

  root 'projects#index'
end
