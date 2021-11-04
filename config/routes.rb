Rails.application.routes.draw do
  resources :articles
  resources :users
  post 'users/login', to:'login#create'
  resources :users do
    resources :articles, only: [:index]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
