Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/merchants/find_all', to: 'merchants#find_all'
      get '/merchants/most_items', to: 'merchants#most_items'
      resources :merchants, only: %i[index show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      namespace :items do
        get '/find', to: 'single_search#show'
      end

      get '/items/find_all', to: 'items#find_items'
      resources :items, only: [:index, :show, :create, :update, :destroy] 
      get '/items/:id/merchant', to: 'items#render_merchant', controller: :items

    end
  end

end
