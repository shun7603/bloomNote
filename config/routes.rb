Rails.application.routes.draw do
  get 'children/new'
  get 'children/index'
  get 'children/create'
  root to: 'homes#index'
  devise_for :users
  get 'up' => 'rails/health#show', as: :rails_health_check
  resources :homes
  resources :children, only: %i[new create index show]
  resources :hospitals, only: %i[new create edit update]
  resources :children do
    resources :records, only: %i[create update destroy]
    resources :routines
  end
end
