Rails.application.routes.draw do
  resources :concepts do
    resources :messages
  end
  devise_for :users
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root to: 'pages#index'

  match '/display_users', to: 'users#index', via: :get
  match '/display_users', to: 'users#create', via: :post
  match '/display_users', to: 'users#destroy', via: :put
  match '/display_users/:id', to: 'users#edit', via: :post
  
  match '/upload', to: 'uploads#index', via: :get
  match '/upload', to: 'uploads#create', via: :post
  
  match '/concepts/:concept_id/messages/:id/upvote', to: 'messages#upvote', as: "upvote", via: :post
  match '/concepts/:concept_id/messages/:id/downvote', to: 'messages#downvote', as: "downvote", via: :post

end
