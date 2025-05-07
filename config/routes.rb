Rails.application.routes.draw do
  root to: 'homes#index'

  devise_for :users

  get 'up' => 'rails/health#show', as: :rails_health_check

  # ✅ 子ども選択用ルート（ドロップダウンからの切替に使用）
  patch 'select_child/:id', to: 'children#select', as: :select_child

  resources :homes, only: [:index]

  resources :children, only: [:new, :create, :index, :show, :update] do
    resources :records, only: [:create, :update, :destroy]
    resources :routines
    resources :hospitals, only: [:new, :create, :update]
  end

  resources :care_relationships, only: [:create, :update, :destroy]
end