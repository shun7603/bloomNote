class CareRelationship < ApplicationRecord
  belongs_to :parent, class_name: 'User'
  belongs_to :caregiver, class_name: 'User'
  belongs_to :child

  enum status: { ongoing: 0, ended: 1 }

  validates :parent_id, :caregiver_id, :child_id, :status, presence: true
end