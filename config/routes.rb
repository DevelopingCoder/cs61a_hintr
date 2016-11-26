Rails.application.routes.draw do
  resources :question_sets do
    resources :questions do
      resources :wrong_answers
    end
  end
  resources :concepts do
    resources :messages
  end
  resources :tag2wronganswers do
    resources :hints
  end
  devise_for :users
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root to: 'pages#index'
  
  match '/forgot_password', to: 'users#forgot_password', as: "forgot_password", via: :post
  
  match '/display_users', to: 'users#index', via: :get
  match '/display_users', to: 'users#create', via: :post
  match '/display_users', to: 'users#destroy', via: :delete
  match '/display_users/:id', to: 'users#edit', via: :put
  
  match '/upload', to: 'uploads#index', via: :get
  match '/upload', to: 'uploads#new', via: :post
  match '/upload/concepts/confirmation', to: 'upload_concepts#show', via: :get
  match '/upload/concepts/confirmation', to: 'upload_concepts#confirm', via: :put
  match '/upload/tags/confirmation', to: 'upload_tags#show', via: :get
  match '/upload/tags/confirmation', to: 'upload_tags#confirm', via: :put
  match '/upload/tag2concepts/confirmation', to: 'upload_tag2concepts#show', via: :get
  match '/upload/tag2concepts/confirmation', to: 'upload_tag2concepts#confirm', via: :put
  
  match 'upload/questionsets/confirmation', to: 'upload_question_sets#show', via: :get
  match 'upload/questionsets/confirmation', to: 'upload_question_sets#confirm', via: :put
  
  match '/concepts/:concept_id/messages/:id/upvote', to: 'messages#upvote', as: "upvote", via: :post
  match '/concepts/:concept_id/messages/:id/downvote', to: 'messages#downvote', as: "downvote", via: :post
  match '/messages/threshold', to: 'messages#edit_threshold', as: "edit_threshold", via: :post
  match '/concepts/:concept_id/messages/:id/finalize', to: 'messages#finalize', as: 'finalize', via: :post
  match '/concepts/:concept_id/messages/:id/finalize', to: 'message#unfinalize', as: 'unfinalize', via: :post
end
