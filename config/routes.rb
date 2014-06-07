Todo::Application.routes.draw do
  namespace :api do 

    resources :users do 
      resources :lists, except: [:index]
    end

    resources :lists, only: [:create, :index, :show, :destroy] do
      resources :items, only: [:create, :new]
    end

  end

  root to: 'users#new'
end
