Rails.application.routes.draw do
  devise_for :users

  # API
  get 'temps/upload' => 'temps#upload'
  get 'pictures/upload-needed' => 'pictures#upload_needed'
  get 'pictures/request-upload' => 'pictures#request_upload'
  get  'pictures/upload' => 'pictures#upload'
  post 'pictures/upload' => 'pictures#upload'
  post 'linebot' => 'pages#linebot'

	# グラフ公開
	get 'temps/graph/:device_id' => 'temps#graph', as: :temps_graph
	get 'temps/graph_data' => 'temps#graph_data'
	get 'temps/last_timestamp' => 'temps#last_timestamp'

	get 'pictures/:id' => 'pictures#show', as: :picture
  get 'pictures-all/:device_id' => 'pictures#index_all', as: :pictures_all

  authenticate :user do
    get 'dashboard' => 'pages#dashboard'
    get 'dashboard-stat1' => 'pages#dashboard_stat1'
    get 'dashboard-mail_logs' => 'pages#dashboard_mail_logs'
    get 'dashboard-pictures' => 'pages#dashboard_pictures'

    get 'tmpr_logs/graph_data'

    resources :devices do
      member do
        get 'publish'
        get 'unpublish'
      end
    end
    resources :addresses
    resources :temps
    resources :temps_dailyes
    resources :temps_monthlies

    get 'users' => 'users#index'
    get 'login-as' => 'users#login_as'
    get 'send_message' => 'addresses#send_message'

    #get 'settings/:device_id/publish' => 'settings#publish'
  end
  # Pages
  get 'about' => 'pages#about'
  get 'howto' => 'pages#howto'
  get 'rules4tester' => 'pages#rules4tester'
  get 'usecase' => 'pages#usecase'
  get 'weather' => 'pages#weather'
  get 'howto4line' => 'pages#howto4line'

  root 'pages#root'
end
