Rails.application.routes.draw do
  namespace :api do
    get 'test/index'
    post 'users', to: 'users#create'
    post 'users/login', to: 'sessions#create'
    get 'user', to: 'users#show'
    post 'articles', to: 'articles#create'
    get 'articles/:slug', to: 'articles#show'
    put 'articles/:slug', to: 'articles#update'
    delete 'articles/:slug', to: 'articles#destroy'
  end
end
