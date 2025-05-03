class CareRelationship < ApplicationRecord
  belongs_to :parent, class_name: 'User'
  belongs_to :caregiver, class_name: 'User'
  belongs_to :child

  enum status: { ongoing: 0, ended: 1 }

  validates :parent, presence: { message: "を入力してください" }
  validates :caregiver, presence: { message: "を入力してください" }
  validates :child, presence: { message: "を入力してください" }
  validates :status, presence: { message: "を入力してください" }
end