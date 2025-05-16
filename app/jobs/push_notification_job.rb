# app/jobs/push_notification_job.rb
class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(record_id)
    record = Record.find_by(id: record_id)
    return unless record

    child = record.child
    caregiver = record.user

    care_relationships = CareRelationship.where(child: child, status: "in_care")

    care_relationships.each do |cr|
      parent = cr.parent
      next if parent.id == caregiver.id
      next if parent.subscription_token.blank?

      subscription = JSON.parse(parent.subscription_token) rescue nil
      next unless subscription

      message = "#{child.name}に#{I18n.t("enums.record.record_type.#{record.record_type}")}の記録をつけました！！（by #{caregiver.nickname}）"

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
    end
  end
end