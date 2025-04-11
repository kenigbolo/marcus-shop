Rails.application.routes.draw do
  namespace :api do
    resources :carts, only: [:show, :create] do
      resources :items, controller: 'cart_items', only: [:create, :destroy]
    end
    resources :carts, only: [:show, :create]
    resources :products, only: [:index, :show, :create, :update, :destroy] do
      resources :parts, only: [:index, :create]
    end
  
    resources :parts, only: [:update, :destroy] do
      resources :part_options, only: [:create]
    end
  
    resources :part_options, only: [:update, :destroy]
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
