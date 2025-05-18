class Routine < ApplicationRecord
  belongs_to :child
  has_one_attached :photo

  validates :time, :task, presence: true

  enum task: {
    milk: 0,          # 🍼 ミルク
    breast_milk: 1,   # 🤱 母乳
    baby_food: 2,     # 🍚 離乳食
    water: 3,         # 💧 水分補給
    sleep: 4,         # 🛌 睡眠
    nap: 5,           # 😴 昼寝
    toilet: 6,        # 🧻 排泄
    temperature: 7,   # 🌡️ 体温
    medicine: 8,      # 💊 服薬
    hospital: 9,      # 🏥 通院・予防接種
    bath: 10,         # 🛁 お風呂
    outing: 11,       # 🚶‍♀️ 外出
    event: 12,        # 🎉 行事
    concern: 13       # 😣 気になる様子
  }

  # 一覧用ラベル（日本語）
  def self.task_labels
    {
      "milk"         => "ミルク",
      "breast_milk"  => "母乳",
      "baby_food"    => "離乳食",
      "water"        => "水分補給",
      "sleep"        => "睡眠",
      "nap"          => "昼寝",
      "toilet"       => "排泄",
      "temperature"  => "体温",
      "medicine"     => "服薬",
      "hospital"     => "通院・予防接種",
      "bath"         => "お風呂",
      "outing"       => "外出",
      "event"        => "行事",
      "concern"      => "気になる様子"
    }
  end

  # セレクト用（[日本語, 英語キー]形式）
  def self.task_options_for_select
    task_labels.map { |k, v| [v, k] }
  end

  # インスタンス用
  def task_label
    I18n.t("enums.record.record_type.#{task}")
  end
end