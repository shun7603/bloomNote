class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token # JSからのPOSTを許可するため

  def create
    return head :unauthorized unless user_signed_in?

    data = params.permit(:endpoint, keys: [:p256dh, :auth])

    current_user.subscriptions.find_or_create_by!(
      endpoint: data[:endpoint]
    ) do |subscription|
      subscription.p256dh_key = data[:keys][:p256dh]
      subscription.auth_key = data[:keys][:auth]
    end

    head :created
  rescue StandardError => e
    Rails.logger.error("🔴 Subscriptionエラー: #{e.message}")
    head :unprocessable_entity
  end
end