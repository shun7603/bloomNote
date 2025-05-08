# app/jobs/routine_reminder_job.rb
class RoutineReminderJob < ApplicationJob
  queue_as :default

  def perform
    target_time = (Time.current + 5.minutes).strftime("%H:%M")

    routines = Routine.includes(child: { care_relationships: :caregiver })
                      .where(time: target_time)

    routines.each do |routine|
      child = routine.child

      if child.care_relationships.ongoing.exists?
        # 🔔 預かり中：保育者だけに通知
        child.care_relationships.ongoing.each do |relationship|
          caregiver = relationship.caregiver
          message = "#{child.name}の『#{routine.task_label}』の時間が5分後です。"
          PushNotificationJob.perform_later(caregiver, message)
        end
      else
        # 🔔 預かりなし：親に通知
        message = "#{child.name}の『#{routine.task_label}』の時間が5分後です。"
        PushNotificationJob.perform_later(child.user, message)
      end
    end
  end
end