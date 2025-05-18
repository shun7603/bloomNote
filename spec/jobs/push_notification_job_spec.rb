require 'rails_helper'

RSpec.describe PushNotificationJob, type: :job do
  let!(:parent) do
    create(:user, role: :role_parent, subscription_token: {
      "endpoint" => "https://fcm.googleapis.com/fake-endpoint",
      "keys" => {
        "p256dh" => Base64.encode64("dummy_p256dh"),
        "auth" => Base64.encode64("dummy_auth")
      }
    }.to_json)
  end

  let!(:caregiver) do
    create(:user, role: :role_caregiver, nickname: "ごはんおじいちゃん")
  end

  let!(:child) do
    create(:child, user: parent, name: "悟空")
  end

  let!(:care_relationship) do
    create(:care_relationship, parent: parent, caregiver: caregiver, child: child)
    # Factoryのデフォルトで status: :ongoing
  end

  let!(:record) do
    create(:record, child: child, user: caregiver, record_type: :milk, category: :nutrition, quantity: 1, recorded_at: Time.current)
  end

  before do
    # 引数がHashで来る場合を想定（Webpush実装が多い）
    allow(Webpush).to receive(:payload_send) do |args|
      puts "CALL: #{args.inspect}"
    end
  end

  it "sends a web push notification with correct message" do
    described_class.perform_now(record.id)

    expected_message = {
      title: "BloomNote",
      body: "悟空にミルクの記録をつけました！！（by ごはんおじいちゃん）"
    }.to_json

    # Base64.encode64は改行を含むので、.stripしないこと（モデルも同じ）
    expect(Webpush).to have_received(:payload_send).with(
      hash_including(
        message: expected_message,
        endpoint: "https://fcm.googleapis.com/fake-endpoint",
        p256dh: Base64.encode64("dummy_p256dh"),
        auth: Base64.encode64("dummy_auth")
      )
    )
  end
end