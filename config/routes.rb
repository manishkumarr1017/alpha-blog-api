Rails.application.routes.draw do
  resources :articles
  resources :users
  resources :users do
    resources :articles, only: [:index]
  end
  resources :categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
