Rails.application.routes.draw do
  resources :articles
  resources :users
  post 'users/login', to:'login#create'
end
