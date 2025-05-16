class SettingsController < ApplicationController
  before_action :authenticate_user!

  def notification
  end

  def subscribe
    current_user.update!(subscription_params)
    head :ok
  end

  private

  def subscription_params
    params.require(:user).permit(:subscription_token)
  end
end
