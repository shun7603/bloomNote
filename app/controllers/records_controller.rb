# app/controllers/records_controller.rb
class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_child

  def create
    @child = Child.find(params[:child_id])
    @record = @child.records.build(record_params)
  
    if @record.save
      redirect_to root_path, notice: "記録が追加されました"
    else
      @children = current_user.children
      @records = @child.records.where(recorded_at: Time.zone.today.all_day)
      render "homes/index"  # ←ここでrenderを使うのがポイント！
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