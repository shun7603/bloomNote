# app/controllers/records_controller.rb
class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child
  before_action :check_caregiver_permissions, only: [:edit, :update, :destroy]
  
  # records_controller.rb
  def create
    redirect_to root_path, alert: "子どもが選択されていません" and return unless current_child
  
    @record = current_child.records.build(record_params.merge(user_id: current_user.id))
    if @record.save
      redirect_to root_path, notice: "記録を追加しました"
    else
      flash[:record_errors]     = @record.errors.full_messages
      flash[:record_attributes] = record_params.to_h
      flash[:record_modal_error] = "true"
      redirect_to root_path
    end
  end

  # app/controllers/records_controller.rb
  def update
    @record = current_user.children.find(params[:child_id]).records.find(params[:id])
    if @record.update(record_params)
      redirect_to root_path, notice: "記録を更新しました"
    else
      flash[:record_errors] = @record.errors.full_messages
      flash[:open_modal] = "editRecordModal-#{@record.id}"  # ←ここ重要！
      redirect_to root_path
    end
  end

  def destroy
    @child = current_user.children.find(params[:child_id])
    @record = @child.records.find(params[:id])
    @record.destroy
    redirect_to root_path, notice: "記録を削除しました"
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def record_params
    params.require(:record).permit(:record_type, :category, :quantity, :recorded_at, :memo)
  end
end

def check_caregiver_permissions
  return unless current_user.caregiver? && @child.shared_with?(current_user)

  redirect_to root_path, alert: "編集権限がありません"
  
end