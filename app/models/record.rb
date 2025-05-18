class Record < ApplicationRecord
  belongs_to :child
  belongs_to :user

  enum record_type: {
    milk: 0,        # 🍼 ミルク
    breast_milk: 1, # 🤱 母乳
    baby_food: 2,   # 🍚 離乳食
    water: 3,       # 💧 水分補給
    sleep: 4,       # 🛌 睡眠
    nap: 5,         # 😴 昼寝
    toilet: 6,      # 🧻 排泄
    temperature: 7, # 🌡️ 体温
    medicine: 8,    # 💊 服薬
    hospital: 9,    # 🏥 通院・予防接種
    bath: 10,       # 🛁 お風呂
    outing: 11,     # 🚶‍♀️ 外出
    event: 12,      # 🎉 行事
    concern: 13     # 😣 気になる様子
  }

  enum category: {
    nutrition: "栄養",
    concern_note: "気になること"
  }

  validates :record_type, :recorded_at, :category, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end