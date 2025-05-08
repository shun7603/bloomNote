FactoryBot.define do
  factory :subscription do
    user { nil }
    endpoint { "MyString" }
    p256dh_key { "MyString" }
    auth_key { "MyString" }
  end
end
