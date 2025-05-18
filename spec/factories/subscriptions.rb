FactoryBot.define do
  factory :subscription do
    association :user
    endpoint { "https://fcm.googleapis.com/fake-endpoint" }
    p256dh_key { Base64.encode64("dummy_p256dh") }
    auth_key { Base64.encode64("dummy_auth") }
  end
end