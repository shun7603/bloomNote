class HomesController < ApplicationController
  before_action :authenticate_user!
  def index
    if user_signed_in?
      @children = current_user.children.includes(:records)
      @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.current
      @records = Record.where(child: @children).where(recorded_at: @selected_date.all_day)
    else
      @children = []
      @records = []
    end
    # 安全にパースし、無効な日付でも落ちないようにする
    @selected_date =
      begin
        params[:date].present? ? Date.parse(params[:date]) : Date.current
      rescue ArgumentError
        Date.current
      end

    @records =
      if @children.first.present?
        @children.first.records.where(recorded_at: @selected_date.all_day).order(recorded_at: :desc)
      else
        []
      end

    @record = Record.new
    @next_task = "ミルク"

    @routine = [
      { time: "08:00", task: "ミルク" },
      { time: "09:00", task: "睡眠" },
      { time: "11:00", task: "排泄" }
    ]

    # ✅ここを追加（保育者リスト用）
    @care_relationships = CareRelationship
                          .includes(:child, :caregiver)
                          .where(parent_id: current_user.id)
  end
end