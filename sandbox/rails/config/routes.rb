Rails.application.routes.draw do
  get 'bme280/:id' => 'bme280#show_graph', as: :bme280
  get 'bme280/data/:id' => 'bme280#show_graph_data', as: :bme280_data
  get 'bme280/raw/:id' => 'bme280#show_raw', as: :bme280_raw

  get 'webcam/:id' => 'webcam#show_images', as: :webcam
  get 'webcam/:id/:date' => 'webcam#show_images_day', as: :webcam_day

  get 'pages/root'
  root 'pages#root'

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
