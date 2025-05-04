Rails.application.routes.draw do
  root to: 'homes#index'

  devise_for :users
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :homes, only: [:index]

  resources :children, only: [:new, :create, :index, :show, :update] do
    resources :records, only: [:create, :update, :destroy]
    resources :routines, only: [:create]
  end

  resources :hospitals, only: [:new, :create, :update]

  resources :care_relationships, only: [:create, :update, :destroy]
end