class Routine < ApplicationRecord
  belongs_to :child

  # ActiveStorage（任意で写真添付）
  has_one_attached :photo

  # 必須バリデーション
  validates :time, :task, :category, presence: true

  # enumカテゴリ（日本語で扱いやすく）
  enum category: {
    nutrition: "栄養",        # 🍼 ミルク・離乳食など
    life: "生活",             # 😴 睡眠・昼寝
    health: "健康",           # 💩 排泄・体温
    medical: "医療",          # 💊 服薬・通院
    schedule: "スケジュール", # 📆 お風呂・外出・行事
    concern: "気になること"  # 😣 気になる体調・様子
  }

  # I18nで表示を統一したい場合はこちら（任意）
  def category_label
    I18n.t("activerecord.attributes.routine.category.#{category}")
  end
end