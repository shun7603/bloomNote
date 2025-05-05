class Routine < ApplicationRecord
  belongs_to :child
  has_one_attached :photo

  validates :time, :task, presence: true

  enum task: {
    milk: 0,
    sleep: 1,
    toilet: 2,
    meal: 3,
    bath: 4,
    walk: 5,
    medicine: 6,
    hospital: 7,
    memo: 8
  }

  # 一覧用ラベル（日本語）
  def self.task_labels
    {
      "milk" => "ミルク",
      "sleep" => "睡眠",
      "toilet" => "排泄",
      "meal" => "ごはん",
      "bath" => "おふろ",
      "walk" => "おさんぽ",
      "medicine" => "薬",
      "hospital" => "病院",
      "memo" => "その他"
    }
  end

  # セレクト用（[日本語, 英語キー]形式）
  def self.task_options_for_select
    task_labels.map { |k, v| [v, k] }
  end

  # インスタンス用
  def task_label
    Routine.task_labels[task]
  end
end