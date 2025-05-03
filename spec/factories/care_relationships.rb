FactoryBot.define do
  factory :care_relationship do
    association :parent, factory: :user
    association :caregiver, factory: :user
    association :child
    status { :ongoing }
  end
end