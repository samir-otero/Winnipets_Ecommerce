Rails.application.routes.draw do

  # Customer-facing routes
  root 'products#index'  # Main homepage (✯ 2.1)
  resources :products, only: [:index, :show]

  # Admin routes
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    get 'dashboard', to: 'dashboard#index'
    root 'dashboard#index' # admin root goes to dashboard

    # Admin resources
    resources :products do
      delete :remove_image, on: :member
    end
    resources :categories
    resources :orders, only: [:index, :show, :update]
    resources :pages, only: [:index, :show, :edit, :update]
  end
end