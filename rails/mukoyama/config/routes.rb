Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    get 'dashboard' => 'pages#dashboard'
    get 'dashboard-stat1' => 'pages#dashboard_stat1'

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
  end
  get 'logs/insert' => 'tmpr_logs#insert'
  post 'upload_jpg' => 'api#upload_jpg'

  get 'about' => 'pages#about'
  get 'howto' => 'pages#howto'
  get 'usecase' => 'pages#usecase'

  post 'linebot' => 'pages#linebot'

  root 'pages#root'
end
