class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child
  before_action :check_caregiver_permissions, only: [:update, :destroy]

  def create
    redirect_to root_path, alert: "子どもが見つかりません" and return unless @child
  
    @record = @child.records.build(record_params.merge(user_id: current_user.id))
  
    if @record.save
      # 🔔 保育者が作成した場合のみ、親にPush通知を送る
      if current_user.role_caregiver? && @child.user.present?
        message = "#{current_user.nickname}さんが #{@child.name}ちゃん の記録を追加しました。"
        PushNotificationJob.perform_now(@child.user, message)
      end
  
      flash[:notification_toast] = "記録を追加しました"
      redirect_to root_path
    else
      flash[:record_modal_error] = "new"
      flash[:record_errors]     = @record.errors.full_messages
      flash[:record_attributes] = record_params.to_h
      redirect_to root_path
    end
  end

  def update
    @record = @child.records.find(params[:id])
    if @record.update(record_params)
      redirect_to root_path, notice: "記録を更新しました"
    else
      flash[:record_errors] = @record.errors.full_messages
      flash[:open_modal] = "editRecordModal-#{@record.id}"
      redirect_to root_path
    end
  end

  def destroy
    @record = @child.records.find(params[:id])
    @record.destroy
    redirect_to root_path, notice: "記録を削除しました"
  end

  private

  def set_child
    @child = Child
             .left_joins(:care_relationships)
             .where(id: params[:child_id])
             .where("children.user_id = :uid OR care_relationships.caregiver_id = :uid", uid: current_user.id)
             .distinct
             .first
  end

  def record_params
    params.require(:record).permit(:record_type, :category, :quantity, :recorded_at, :memo)
  end

  def check_caregiver_permissions
    return unless current_user.role_caregiver?

    redirect_to root_path, alert: "編集・削除はできません" and return
    
  end
end