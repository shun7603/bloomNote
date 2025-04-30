# app/models/child.rb
class Child < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :birth_date, presence: true
  validates :gender, presence: true

  enum gender: { unspecified: 0, boy: 1, girl: 2 }
end