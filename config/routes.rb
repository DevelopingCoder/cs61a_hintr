Rails.application.routes.draw do
  resources :comments
  devise_for :users
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root to: 'pages#index'
  
  match '/display_users', to: 'pages#display_users', via: :get
  match '/display_users', to: 'pages#add_user', via: :post
  match '/display_users', to: 'pages#delete_user', via: :put
  match '/upload', to: 'pages#upload_menu', via: :get
end