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
end
