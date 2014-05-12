ServerSerialPort::Application.routes.draw do
  resources :settings

  resources :lendings

  get "image/load"
  get "image/save"
  get "image/manipulation"
  get "image/index"
  get "image/live"
  get "image/compare"
  get "image/distance_diference"
  
  resources :books

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  #Refresh_header is used to update weight
  get "refresh_header" => "welcome#refresh_header"

  #request for new lending, this function is used in browser request
  post "lendings/init_lending" => "lendings#init_lending"

  #Search route to search book by weight
  get 'search',  to: 'books#search', as: :search

  #Get url image from selected book
  get 'get_url_image' => 'books#get_url_image'

  #This route represent the koha request, this request is a POST with JSON request
  post 'koha_request' => 'lendings#koha_request'

  post 'change_camera' => 'settings#change_camera'

  

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
