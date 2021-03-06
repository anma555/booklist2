Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:create]

  resources :books, only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      get :search
      post :search
    end
  end
end
