Rails.application.routes.draw do
  devise_for :users

  # API
  get 'temps/upload' => 'temps#upload'
  get 'pictures/upload-needed' => 'pictures#upload_needed'
  get 'pictures/request-upload' => 'pictures#request_upload'
  get  'pictures/upload' => 'pictures#upload'
  post 'pictures/upload' => 'pictures#upload'
  get 'pictures/download' => 'pictures#download'
  get 'pictures/download_this/:device_id(/:date)' => 'pictures#download_this', :as => 'pictures_download_this'
  post 'linebot' => 'pages#linebot'

	# グラフ公開
	get 'temps/graph/:device_id' => 'temps#graph', as: :temps_graph
	get 'temps/graph_data' => 'temps#graph_data'
	get 'temps/:id/latest' => 'temps#latest'

	get 'pictures/:id' => 'pictures#show', as: :picture
  # グループ化は一旦置いといて、こっちをメインに使う(motionの利用を主とする方針)
  get 'pictures' => 'pictures#index', as: :pictures

  get 'devices/:id/picture' => 'devices#picture', as: :device_picture

  authenticate :user do
    get 'dashboard' => 'pages#dashboard'
    get 'dashboard-stat1' => 'pages#dashboard_stat1'
    get 'dashboard-stat2' => 'pages#dashboard_stat2'
    get 'dashboard-mail_logs' => 'pages#dashboard_mail_logs'
    get 'dashboard-pictures' => 'pages#dashboard_pictures'

    get 'tmpr_logs/graph_data'

    get 'temps/download' => 'temps#download'

    resources :devices do
      member do
        get 'publish'
        get 'unpublish'
        get 'destroy_data'
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
  get 'weather4city' => 'pages#weather4city'
  get 'howto4line' => 'pages#howto4line'
  get 'doc/:name' => 'pages#doc'

  root 'pages#root'
end
