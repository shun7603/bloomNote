class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :discard_devise_flash

  helper_method :current_child

  protected

  # Deviseのストロングパラメータ設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :role])
  end

  # 選択中の子どもを取得（共通メソッド）
  def current_child
    @current_child ||= Child.find_by(id: session[:selected_child_id])
  end

  # Devise由来のnotice/alertを表示させない
  def discard_devise_flash
    return unless devise_controller?

    flash.discard(:notice)
    flash.discard(:alert)
  end
end