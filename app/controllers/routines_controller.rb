class RoutinesController < ApplicationController
  belongs_to :child

  enum category: { milk: 0, sleep: 1, toilet: 2, meal: 3 }

  validates :time, :task, :category, presence: true
end
