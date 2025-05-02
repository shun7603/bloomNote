class CareRelationship < ApplicationRecord
  belongs_to :parent, class_name: 'User'
  belongs_to :caregiver, class_name: 'User'
  belongs_to :child

  enum status: { active: 0, closed: 1 }

  validates :parent_id, :caregiver_id, :child_id, :status, presence: true
end