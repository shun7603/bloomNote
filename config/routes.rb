Rails.application.routes.draw do
  get 'settings/notification'
  get 'settings/subscribe'
  root to: 'homes#index'

  devise_for :users
  # 通知設定ページ用ルート
  get "/settings/notification", to: "settings#notification"
  post "/settings/subscribe", to: "settings#subscribe"
  get 'up' => 'rails/health#show', as: :rails_health_check

  # ✅ 子ども選択用ルート（ドロップダウンからの切替に使用）
  patch 'select_child/:id', to: 'children#select', as: :select_child

  resources :homes, only: [:index]
  resources :subscriptions, only: [:create]
  resources :children do
    resources :records, only: [:create, :update, :destroy]
    resources :routines
    resources :hospitals, only: [:new, :create, :update]
  end

  resources :care_relationships, only: [:create, :update, :destroy]
end