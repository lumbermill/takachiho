Rails.application.routes.draw do
  devise_for :users

  # API
  get 'logs/insert' => 'tmpr_logs#insert'
  get 'pictures/upload-needed' => 'pictures#upload_needed'
  post 'pictures/upload' => 'pictures#upload'
  post 'linebot' => 'pages#linebot'

	# グラフ公開
	get 'tmpr_logs/graph/:raspi_id' => 'tmpr_logs#graph', as: :tmpr_logs_graph
	get 'tmpr_logs/graph_data' => 'tmpr_logs#graph_data'
	get 'logs/last_timestamp' => 'tmpr_logs#last_timestamp'

	get 'pictures/:raspi_id' => 'pictures#index', as: :pictures
	get 'pictures/:raspi_id/:time_stamp' => 'pictures#show', as: :picture

  authenticate :user do
    get 'dashboard' => 'pages#dashboard'
    get 'dashboard-stat1' => 'pages#dashboard_stat1'
    get 'dashboard-mail_logs' => 'pages#dashboard_mail_logs'
    get 'dashboard-pictures' => 'pages#dashboard_pictures'

    get 'tmpr_logs/graph_data'

    resources :settings do
      member do
        get 'publish'
        get 'unpublish' 
      end
    end
    resources :addresses
    resources :tmpr_monthly_logs
    resources :tmpr_daily_logs
    resources :tmpr_logs

    get 'users' => 'users#index'
    get 'login-as' => 'users#login_as'
    get 'send_message' => 'addresses#send_message'

    get 'pictures/request-upload' => 'pictures#request_upload'
    #get 'settings/:raspi_id/publish' => 'settings#publish'
  end
  # Pages
  get 'about' => 'pages#about'
  get 'howto' => 'pages#howto'
  get 'rules4tester' => 'pages#rules4tester'
  get 'usecase' => 'pages#usecase'

  root 'pages#root'
end
