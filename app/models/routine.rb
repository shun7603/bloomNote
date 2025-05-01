class Routine < ApplicationRecord
  belongs_to :child

  # ActiveStorage（写真つけたい場合）
  has_one_attached :photo

  # 必須項目
  validates :time, presence: true
  validates :task, presence: true
  validates :category, presence: true

  # カテゴリ（enumで定義するとフォームで使いやすい）
  enum category: {
    nutrition: "栄養",      # 🍼 ミルク・離乳食など
    life: "生活",           # 😴 睡眠・昼寝
    health: "健康",         # 💩 排泄・体温
    medical: "医療",        # 💊 服薬・通院
    schedule: "スケジュール", # 📆 お風呂・外出・行事
    concern: "気になること"  # 😣 気になる体調・様子
  }
end