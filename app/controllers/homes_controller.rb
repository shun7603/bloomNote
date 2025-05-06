class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @children      = current_user.children.includes(:records, :routines)
    @selected_date = parse_date(params[:date])
    @record        = Record.new

    if (child = @children.first)
      # 📋 今日の記録一覧（最新順）
      @records = child.records
                      .where(recorded_at: @selected_date.all_day)
                      .order(recorded_at: :desc)

      # 🔁 ルーティン一覧（時刻順）
      @routines = child.routines.order(:time)

      # ⏰ 今やるべきルーティンを抽出（現在時刻より後、最も近いもの）
      current_time = Time.zone.now

      @next_routine = @routines.find do |routine|
        today_time = Time.zone.local(current_time.year, current_time.month, current_time.day,
                                     routine.time.hour, routine.time.min, routine.time.sec)
        today_time > current_time
      end

      # 💬 表示用プロパティ（補助的に使用する場合）
      @next_task_label     = @next_routine&.task_label || "未定"
      @next_routine_time   = @next_routine&.time&.strftime("%H:%M")
    else
      # 🛑 子ども未登録時の初期化
      @records             = []
      @routines            = []
      @next_routine        = nil
      @next_task_label     = "未定"
      @next_routine_time   = nil
    end

    # 👩‍👧 保育者リスト（親が追加したもの）
    @care_relationships = current_user.care_relationships.includes(:child, :caregiver)
  end

  private

  # params[:date] が不正でも落ちないようにパース
  def parse_date(date_str)
    return Date.current if date_str.blank?

    Date.parse(date_str)
  rescue ArgumentError
    Date.current
  end
end