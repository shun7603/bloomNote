class CareRelationship < ApplicationRecord
  belongs_to :parent
  belongs_to :caregiver
  belongs_to :child
end
