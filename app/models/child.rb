class Child < ApplicationRecord
  belongs_to :user
  has_many :routines, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :care_relationships, dependent: :destroy

  validates :name, presence: true
  validates :birth_date, presence: true
  validates :gender, presence: true

  enum gender: { unspecified: 0, boy: 1, girl: 2 }

  # ✅ この子が指定ユーザーに共有されているか？
  def shared_with?(user)
    care_relationships.exists?(caregiver_id: user.id, status: CareRelationship.statuses[:ongoing])
  end

  # ✅ 閲覧可能な子ども一覧スコープ（親 or 保育者 with ongoing）
  scope :accessible_by, lambda { |user|
    left_joins(:care_relationships)
      .where(
        "children.user_id = :uid OR (care_relationships.caregiver_id = :uid AND care_relationships.status = :status)",
        uid: user.id,
        status: CareRelationship.statuses[:ongoing]
      )
      .distinct
  }
end