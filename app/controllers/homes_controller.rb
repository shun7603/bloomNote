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

    if @children.first.present?
      child = @children.first

      # 📋 今日の記録一覧（最新が上）
      @records = child.records
                      .where(recorded_at: @selected_date.all_day)
                      .order(recorded_at: :desc)

      # 🍼 新規記録フォーム用
      @record = Record.new

      # 🔁 ルーティン一覧（時刻順）
      @routines = child.routines.order(:time)

      # ⏰ 今やるべきルーティンを抽出
      now_time = Time.current.strftime('%H:%M') # 現在時刻を "HH:MM" 文字列に
      @next_routine = @routines.find { |r| r.time.strftime('%H:%M') > now_time }

      # 📌 今やるべきタスク名と表示用文字列
      @next_task = @next_routine&.task || "未定"
      @next_routine_time = @next_routine&.time&.strftime('%H:%M')
      @next_routine_task = begin
        Routine.tasks[@next_routine&.task&.to_sym]
      rescue StandardError
        nil
      end
    else
      @records = []
      @routines = []
      @record = Record.new
      @next_task = "未定"
      @next_routine_time = nil
      @next_routine_task = nil
    end

    # 👩‍👧 保育者関係一覧（親が追加したもの）
    @care_relationships = CareRelationship
                          .includes(:child, :caregiver)
                          .where(parent_id: current_user.id)
  end
end