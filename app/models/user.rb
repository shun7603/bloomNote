class User < ApplicationRecord
  # Deviseの設定
  has_many :children
  has_many :hospitals 
  has_many :care_relationships_as_parent, class_name: 'CareRelationship', foreign_key: 'parent_id'
  has_many :care_relationships_as_caregiver, class_name: 'CareRelationship', foreign_key: 'caregiver_id'


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true
  validates :role, presence: true

  enum role: { role_parent: 0, role_caregiver: 1 }
end