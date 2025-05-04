class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @children = current_user.children.includes(:records, :routines)
    @selected_date =
      begin
        params[:date].present? ? Date.parse(params[:date]) : Date.current
      rescue ArgumentError
        Date.current
      end

    @records =
      if @children.first.present?
        @children.first.records
                 .where(recorded_at: @selected_date.all_day)
                 .order(recorded_at: :desc)
      else
        []
      end

    # 🍼 新規記録投稿用フォームオブジェクト
    @record = Record.new

    # 🔁 子どもがいるときのみルーティン取得（例: 08:00 ミルクなど）
    @routines =
      if @children.first.present?
        @children.first.routines.order(:time)
      else
        []
      end

    # 💡 表示する今やるべきタスク（簡易ダミー）
    @next_task = @routines.first&.task || "未定"

    # 👩‍👧 保育者関係一覧（親が追加したもの）
    @care_relationships = CareRelationship
                          .includes(:child, :caregiver)
                          .where(parent_id: current_user.id)
  end
end