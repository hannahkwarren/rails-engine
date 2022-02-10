Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do 
      get "/merchants/find", to: "merchants#find"

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      get "/items/find", to: "items#find_item"
      get "/items/find_all", to: "items#find_items"

      resources :items, only: [:index, :show, :create, :update, :destroy] 
      
      get "/items/:id/merchant", to: 'items#render_merchant', controller: :items
    end
  end

end
