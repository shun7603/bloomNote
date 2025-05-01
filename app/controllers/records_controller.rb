# app/controllers/records_controller.rb
class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child

  def create
    @record = @child.records.build(record_params)
    if @record.save
      redirect_to root_path, notice: "記録が追加されました"
    else
      redirect_to root_path, alert: "記録に失敗しました"
    end
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def record_params
    params.require(:record).permit(:record_type, :category, :quantity, :recorded_at, :memo)
  end
end