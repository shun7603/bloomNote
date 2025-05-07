class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    # 子ども一覧（親として or 保育者として預かっている子ども）
    @children = Child
                .left_joins(:care_relationships)
                .where(
                  "children.user_id = :uid OR care_relationships.caregiver_id = :uid",
                  uid: current_user.id
                )
                .where("care_relationships.status IS NULL OR care_relationships.status = ?", CareRelationship.statuses[:ongoing])
                .distinct

    # 現在選択中の子ども（セッションから取得 or 一番上の子）
    @current_child = if session[:selected_child_id]
                       @children.find_by(id: session[:selected_child_id])
                     else
                       @children.first
                     end

    @is_shared_child = @current_child.present? && @current_child.shared_with?(current_user)
    # モデルインスタンスの準備（モーダル用）
    @record    = Record.new
    @hospital  = Hospital.new
    @routine   = Routine.new
    @child     = Child.new
    @care_relationship = CareRelationship.new

    # CareRelationship一覧（関係者モーダルに使用）
    @care_relationships =
      if current_user.role_parent?
        CareRelationship.includes(:child, :parent, :caregiver)
                        .where(parent_id: current_user.id)
      else
        CareRelationship.includes(:child, :parent, :caregiver)
                        .where(caregiver_id: current_user.id)
      end

    # 日付選択
    @selected_date = parse_date(params[:date])

    if @current_child.present?
      # 育児記録
      @records = @current_child.records
                               .where(recorded_at: @selected_date.all_day)
                               .order(recorded_at: :desc)

      # ルーティン一覧
      @routines = @current_child.routines.order(:time)

      # 今やるべきルーティン（時間が現在より先のものを1件）
      current_time = Time.zone.now
      @next_routine = @routines.find do |routine|
        today_time = Time.zone.local(current_time.year, current_time.month, current_time.day,
                                     routine.time.hour, routine.time.min, routine.time.sec)
        today_time > current_time
      end
    else
      @records = []
      @routines = []
      @next_routine = nil
    end
  end

  private

  def parse_date(date_param)
    date_param.present? ? Date.parse(date_param) : Time.zone.today
  rescue ArgumentError
    Time.zone.today
  end
end