Todo::Application.routes.draw do
  namespace :api do 

    resources :users do 
      resources :lists, except: [:index]
    end

    resources :lists, only: [:create, :index] do
      resources :items, only: [:create, :new]
    end

    resources :items, only: [:destroy]

    root to: 'users#new'
  end
end
