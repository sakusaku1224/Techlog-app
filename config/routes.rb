Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :users, only: [:show]
end
