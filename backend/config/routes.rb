Rails.application.routes.draw do
  namespace :api do
    get 'test/index'
    post 'users', to: 'users#create'
    post 'users/login', to: 'sessions#create'
  end
end
