FactoryBot.define do
  factory :user do
    nickname { "育児パパ" }
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    role { :parent }
  end
end