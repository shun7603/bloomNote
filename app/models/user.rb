class User < ApplicationRecord
  # Devise（ユーザー認証機能）
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # enum（ユーザーの役割を切り替えられる）
  enum role: { guardian: 0, caregiver: 1 } 
end