FactoryBot.define do
  factory :record do
    association :user
    association :child

    record_type { Record.record_types.keys.sample }
    category { Record.categories.keys.sample }
    quantity { Faker::Number.between(from: 1, to: 5) }
    recorded_at { Faker::Time.between(from: 2.days.ago, to: Time.current, format: :default) }
    memo { Faker::Lorem.sentence(word_count: 5) }
  end
end