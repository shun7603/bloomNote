Rails.application.routes.draw do
  get 'children/new'
  get 'children/index'
  get 'children/create'
  root to: "homes#index"
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  resources :homes 
  resources :children, only: [:new, :create, :index, :show]
  resources :hospitals, only: [:new, :create, :edit, :update]
  resources :children do
    resources :records, only: [:create, :update, :destroy]
    resources :routines
  end
end