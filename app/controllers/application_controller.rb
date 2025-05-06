class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_child

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :role])
  end

  # 選択中の子どもを返す共通メソッド
  def current_child
    @current_child ||= Child.find_by(id: session[:current_child_id])
  end
end