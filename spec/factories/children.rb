FactoryBot.define do
  factory :child do
    association :user
    name { "テストちゃん" }
    birth_date { Date.today - 1.year }
    gender { "boy" } # 必要ならstringで保存されてるgenderに合わせて調整
  end
end