class CareRelationship < ApplicationRecord
  belongs_to :parent, class_name: 'User'
  belongs_to :caregiver, class_name: 'User'
  belongs_to :child

  enum status: { ongoing: 0, ended: 1 }

  # 日本語化ヘルパー
  def status_i18n
    I18n.t("enums.care_relationship.status.#{status}")
  end

  # バリデーション
  validates :parent, presence: { message: "を入力してください" }
  validates :caregiver, presence: { message: "を入力してください" }
  validates :child, presence: { message: "を入力してください" }
  validates :status, presence: { message: "を入力してください" }

  validate :parent_cannot_be_caregiver

  private

  def parent_cannot_be_caregiver
    return unless parent_id == caregiver_id

    errors.add(:caregiver_id, "に自分自身は指定できません")
  end
end