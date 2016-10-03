Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    get 'dashboard' => 'pages#dashboard'

    get 'tmpr_logs/graph/:raspi_id' => 'tmpr_logs#graph', as: :tmpr_logs_graph
    get 'tmpr_logs/graph_data'
    get 'tmpr_logs/insert'

    resources :settings
    resources :addresses
    resources :tmpr_monthly_logs
    resources :tmpr_daily_logs
    resources :tmpr_logs

    get 'users' => 'users#index'
  end

  get 'about' => 'pages#about'
  get 'howto' => 'pages#howto'

  root 'pages#root'
end
