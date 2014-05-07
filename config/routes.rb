MatchChat::Application.routes.draw do
  devise_for :users
  resources :chatrooms

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'topics#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  resources :chatrooms do
    resources :messages
  end

  put '/end_chat/:id', to: 'chatrooms#end_chat', as: 'end_chat'

  resources :messages do
    resources :users
  end

  resources :users, only: [:show, :edit, :destroy]

  resources :heartbeats

  post '/topics/:id/new_giver', to: 'topics#register_giver', as: 'new_giver'

  post '/topics/:id/new_taker', to: 'topics#register_taker', as: 'new_taker'

  get '/topics/:id/add_question', to: 'topics#add_question', as: 'add_question'

  resources :topics, only: [:index, :show]

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
