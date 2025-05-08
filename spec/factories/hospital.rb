FactoryBot.define do
  factory :hospital do
    association :user
    association :child
    name { "緊急病院" }
    phone_number { "09012345678" }
  end
end