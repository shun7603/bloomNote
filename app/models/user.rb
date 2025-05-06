# app/models/user.rb
class User < ApplicationRecord
  # Devise の設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :nickname, presence: true
  validates :role,     presence: true

  # 子どもと病院
  has_many :children, dependent: :destroy
  has_many :hospitals, dependent: :destroy

  # 親としてのケアリレーションシップ（親が追加したもの）
  has_many :care_relationships,
           class_name: 'CareRelationship',
           foreign_key: 'parent_id',
           dependent: :destroy

  # 保育者として紐づくケアリレーションシップ（必要に応じて参照用に残す）
  has_many :care_relationships_as_caregiver,
           class_name: 'CareRelationship',
           foreign_key: 'caregiver_id'

  # enum（ユーザー権限）
  enum role: { role_parent: 0, role_caregiver: 1 }
  def can_access?(child)
    return true if child.user_id == id # 親ならアクセス可能

    # 保育者で「共有中」の関係があるか
    CareRelationship.exists?(
      child_id: child.id,
      caregiver_id: id,
      status: :ongoing
    )
  end
end