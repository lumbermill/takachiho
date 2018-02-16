Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'howto' => 'pages#howto'

  devise_for :users

  authenticate :user do
    get 'dashboard' => 'pages#dashboard'
    resources :tags
    resources :items
  end

  root 'pages#root'
end
