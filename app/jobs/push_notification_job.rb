class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(record_id)
    record = Record.find_by(id: record_id)
    unless record
      Rails.logger.warn "❌ PushNotificationJob: record_id=#{record_id} が見つかりません"
      return
    end

    child = record.child
    caregiver = record.user

    care_relationships = CareRelationship.where(child: child, status: "ongoing")

    care_relationships.each do |cr|
      parent = cr.parent
      next if parent.id == caregiver.id
      next if parent.subscription_token.blank?

      subscription = begin
        JSON.parse(parent.subscription_token)
      rescue StandardError
        nil
      end
      next unless subscription

      message = "#{child.name}に#{I18n.t("enums.record.record_type.#{record.record_type}")}の記録をつけました！！（by #{caregiver.nickname}）"

      Rails.logger.info "📢 PushNotificationJob: parent_id=#{parent.id} (#{parent.nickname}) へ通知送信を開始"

      begin
        Webpush.payload_send(
          message: JSON.generate(title: "BloomNote", body: message),
          endpoint: subscription["endpoint"],
          p256dh: subscription["keys"]["p256dh"],
          auth: subscription["keys"]["auth"],
          vapid: {
            subject: "mailto:your-email@example.com",
            public_key: ENV["VAPID_PUBLIC_KEY"],
            private_key: ENV["VAPID_PRIVATE_KEY"]
          }
        )
        Rails.logger.info "✅ PushNotificationJob: parent_id=#{parent.id} (#{parent.nickname}) へ通知送信成功"
      rescue StandardError => e
        Rails.logger.error "❌ PushNotificationJob: parent_id=#{parent.id} への通知送信失敗 - #{e.class}: #{e.message}"
      end
    end
  end
end