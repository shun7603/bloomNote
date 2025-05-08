class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(user, message)
    vapid_keys = {
      public_key: ENV['VAPID_PUBLIC_KEY'],
      private_key: ENV['VAPID_PRIVATE_KEY']
    }

    user.subscriptions.find_each do |subscription|
      Webpush.payload_send(
        message: JSON.generate({ title: "BloomNote", body: message }),
        endpoint: subscription.endpoint,
        p256dh: subscription.p256dh_key,
        auth: subscription.auth_key,
        vapid: {
          subject: "mailto:example@example.com",
          public_key: vapid_keys[:public_key],
          private_key: vapid_keys[:private_key]
        }
      )
    rescue StandardError => e
      Rails.logger.error "🔴 Push通知失敗: #{e.message}"
    end
  end
end