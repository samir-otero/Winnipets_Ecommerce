Rails.application.routes.draw do

  # Customer-facing routes
  root 'home#index'  # Main homepage (✯ 2.1)
  resources :products, only: [:index, :show]

  # Shopping Cart routes (✯ 3.1.1)
  get 'cart', to: 'cart#show'
  post 'cart/add/:id', to: 'cart#add_item', as: 'add_item_cart'
  delete 'cart/remove/:id', to: 'cart#remove_item', as: 'remove_item_cart'
  get 'cart/remove/:id', to: 'cart#remove_item'
  patch 'cart/update/:id', to: 'cart#update_quantity', as: 'update_quantity_cart'
  delete 'cart/clear', to: 'cart#clear', as: 'clear_cart'
  get 'cart/clear', to: 'cart#clear'

  # Checkout routes (✯ 3.1.3)
  get 'checkout', to: 'checkout#new', as: 'new_checkout'
  post 'checkout', to: 'checkout#create', as: 'checkout'
  get 'checkout/confirmation', to: 'checkout#confirmation', as: 'checkout_confirmation'
  post 'checkout/process', to: 'checkout#process_order', as: 'process_order_checkout'
  get 'orders/:id/confirmation', to: 'checkout#order_confirmation', as: 'order_confirmation'

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