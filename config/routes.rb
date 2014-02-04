DinnerDash::Application.routes.draw do
  devise_for :users
  devise_for :admins
  authenticated :admin do
    root to: "dashboards#show", as: :authenticated_root
  end

  root 'products#index'
  resources :products, except: [:destroy] do
    get 'retired', on: :collection
  end

  resources :categories, only: [:new, :create, :show, :edit, :update]
  resources :line_items, only: [:create, :update, :destroy]
  get 'cart', to: "cart#show"
  resources :transactions, only: [:new, :create]
  resource :dashboard, only: [:show]

  resources :orders, only: [:edit, :update] do
    patch 'cancel', on: :member
    patch 'paid', on: :member
    patch 'complete', on: :member
  end

  resources :users do
    resources :orders, only: [:index, :show]
  end

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
