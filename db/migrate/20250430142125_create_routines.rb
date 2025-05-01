class CreateRoutines < ActiveRecord::Migration[7.1]
  def change
    create_table :routines do |t|
      t.references :child, null: false, foreign_key: true

      # 共通
      t.string :time, null: false           # 実施予定時刻
      t.string :task, null: false           # タスク名（ミルク・睡眠など）
      t.string :category, null: false       # カテゴリ（栄養、生活、健康など）
      t.text :memo                          # 備考、症状、日記など自由記述
      t.boolean :important, default: false  # 緊急性フラグ

      # 栄養関連
      t.integer :quantity                   # 量（ml・g）
      t.integer :count                      # 回数（1日2回など）

      # 健康・体調
      t.float :temperature                  # 体温
      t.string :condition                   # 排泄の状態や体調変化（例："少し硬い", "ぐったり気味"）

      # 医療系
      t.string :medicine_name               # 薬の名前
      t.string :hospital_name               # 病院名

      # スケジュール・記録系
      t.string :event_type                  # 行事・外出などの種類（例："お風呂", "お宮参り"）

      t.timestamps
    end
  end
end