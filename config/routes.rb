Makasa::Application.routes.draw do
  get "my_post/index"
  get "my_post/show"
  get "my_post/new"
  get "my_post/edit"
  resources :posts

  get "access/index"
  get "access/login"
  resources :users

  get "logout" => 'access#logout'

  get "login_access" => 'access#login_access'

  get 'request_access' => 'access#request_access'

  post "password_request" => "access#password_request"

  post "access/attempt_login" => 'access#attempt_login'

  get "access/:access/password_reset_access/:ref" => "access#password_reset_access"

  patch 'users/:id/password_request_update' => 'users#password_request_update'

  root 'posts#index'

  get ':username/edit' => 'users#edit'

  patch 'users/:id/avatar_update' => 'users#avatar_update'

  patch 'users/:id/password_update' => 'users#password_update'

  get ":username" => 'users#show'

  post 'connected_post/:connected_id' => 'posts#connected_post'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
