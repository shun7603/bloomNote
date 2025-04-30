class Child < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :birth_date, presence: true
end