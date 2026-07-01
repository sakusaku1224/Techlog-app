Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :posts, only: [:index, :new, :create, :show, :destroy]
end
