Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    get 'dashboard' => 'pages#dashboard'
    get 'dashboard-stat1' => 'pages#dashboard_stat1'
    get 'dashboard-mail_logs' => 'pages#dashboard_mail_logs'
    get 'dashboard-pictures' => 'pages#dashboard_pictures'

    get 'tmpr_logs/graph/:raspi_id' => 'tmpr_logs#graph', as: :tmpr_logs_graph
    get 'tmpr_logs/graph_data'

    resources :settings
    resources :addresses
    resources :tmpr_monthly_logs
    resources :tmpr_daily_logs
    resources :tmpr_logs

    get 'users' => 'users#index'
    get 'login-as' => 'users#login_as'
    get 'logs/last_timestamp' => 'tmpr_logs#last_timestamp'
    get 'send_message' => 'addresses#send_message'

    get 'pictures/:raspi_id' => 'pictures#index', as: :pictures
    get 'pictures/:raspi_id/:time_stamp' => 'pictures#show', as: :picture
  end
  # API
  get 'logs/insert' => 'tmpr_logs#insert'
  post 'pictures/upload' => 'pictures#upload'
  post 'linebot' => 'pages#linebot'

  # Pages
  get 'about' => 'pages#about'
  get 'howto' => 'pages#howto'
  get 'rules4tester' => 'pages#rules4tester'
  get 'usecase' => 'pages#usecase'

  root 'pages#root'
end
