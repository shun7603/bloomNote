# app/models/routine.rb
class Routine < ApplicationRecord
  belongs_to :child
  has_one_attached :photo

  validates :time, :task, :category, presence: true

  # taskをrecord_typeと同じ種類でenum化
  enum task: {
    milk: "ミルク",
    sleep: "睡眠",
    toilet: "排泄",
    meal: "ごはん",
    bath: "おふろ",
    walk: "おさんぽ",
    medicine: "薬",
    hospital: "病院",
    memo: "その他"
  }

  enum category: {
    nutrition: "栄養",
    life: "生活",
    health: "健康",
    medical: "医療",
    schedule: "スケジュール",
    concern: "気になること"
  }
end