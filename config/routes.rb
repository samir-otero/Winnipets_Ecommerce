Rails.application.routes.draw do
  # Root route (we'll create this later)
  root 'home#index'

  # Admin routes
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    get 'dashboard', to: 'dashboard#index'
    root 'dashboard#index' # admin root goes to dashboard
    resources :products do
      delete :remove_image, on: :member
    end

    # Admin resources (we'll add more later)
    resources :products
    resources :categories
    resources :orders, only: [:index, :show, :update]
    resources :pages, only: [:index, :show, :edit, :update]
  end
end