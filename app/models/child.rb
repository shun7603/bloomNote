# app/models/child.rb
class Child < ApplicationRecord
  belongs_to :user
  has_many :routines, dependent: :destroy
  has_many :records, dependent: :destroy
  
  validates :name, presence: true
  validates :birth_date, presence: true
  validates :gender, presence: true

  enum gender: { unspecified: 0, boy: 1, girl: 2 }
end