FactoryBot.define do
  factory :routine do
    association :child
    time { "09:00" }
    task { :milk }
  end
end