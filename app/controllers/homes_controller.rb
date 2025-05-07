class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分が親 or 保育者として関わっている子ども（保育者は ongoing のみ）
    @children = Child
                .left_outer_joins(:care_relationships)
                .where(
                  "children.user_id = :user_id OR (care_relationships.caregiver_id = :user_id AND care_relationships.status = :ongoing)",
                  user_id: current_user.id,
                  ongoing: CareRelationship.statuses[:ongoing]
                )
                .distinct

    # セッションに保存された子どもIDがあれば使用、なければ自分が親の子を優先的に選択
    @current_child = @children.find_by(id: session[:selected_child_id])
    unless @current_child
      session.delete(:selected_child_id)
      @current_child = @children.find { |child| child.user_id == current_user.id } || @children.first
    end

    # 保育者が共有中の子どもかどうか（ビュー制御用）
    @is_shared_child = @current_child&.shared_with?(current_user)

    # モーダル用新規インスタンス
    @record            = Record.new
    @hospital          = flash[:hospital_attributes].present? ? Hospital.new(flash[:hospital_attributes]) : Hospital.new
    @routine           = Routine.new
    @child             = Child.new
    @care_relationship = CareRelationship.new

    # 保育関係（親または保育者として）
    @care_relationships =
      if current_user.role_parent?
        CareRelationship.includes(:child, :parent, :caregiver)
                        .where(parent_id: current_user.id)
      else
        CareRelationship.includes(:child, :parent, :caregiver)
                        .where(caregiver_id: current_user.id)
      end

    # 表示する日付（指定がなければ今日）
    @selected_date = parse_date(params[:date])

    # 子どもが選択されている場合のみ、関連情報を取得
    if @current_child.present?
      @records = @current_child.records
                               .where(recorded_at: @selected_date.all_day)
                               .order(recorded_at: :desc)

      @routines = @current_child.routines.order(:time)

      # 今から次のルーティンを取得
      current_time = Time.zone.now
      @next_routine = @routines.find do |routine|
        routine_time = Time.zone.local(
          current_time.year, current_time.month, current_time.day,
          routine.time.hour, routine.time.min, routine.time.sec
        )
        routine_time > current_time
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