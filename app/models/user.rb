class User < ApplicationRecord
  # Deviseの設定
  has_many :children
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true
  validates :role, presence: true

  enum role: { role_parent: 0, role_caregiver: 1 }
end