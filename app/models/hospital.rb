# app/models/hospital.rb
class Hospital < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :phone_number, presence: true, format: { with: /\A0\d{1,4}-?\d{1,4}-?\d{3,4}\z/, message: "は有効な電話番号を入力してください" }
end