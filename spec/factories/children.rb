FactoryBot.define do
  factory :child do
    association :user
    name { Faker::Name.first_name + "ちゃん" }
    birth_date { Faker::Date.between(from: '2020-01-01', to: Date.today) }
    gender { Child.genders.keys.sample }
  end
end