class CareRelationshipsController < ApplicationController
  before_action :set_homes_data, only: [:create]

  def create
    caregiver = User.find_by(email: care_relationship_params[:caregiver_email])
    child = Child.find_by(id: care_relationship_params[:child_id])

    if caregiver && child
      care_relationship = CareRelationship.new(
        parent: current_user,
        caregiver: caregiver,
        child: child,
        status: :ongoing
      )

      if care_relationship.save
        @care_relationship = care_relationship
        flash.now[:notice] = "保育者を追加しました"

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to root_path, notice: flash[:notice] }
        end
      else
        flash.now[:care_relationship_errors] = care_relationship.errors.full_messages
        flash.now[:open_modal] = 'addCareRelationshipModal'
        render 'homes/index', status: :unprocessable_entity
      end
    else
      flash.now[:care_relationship_errors] = []
      flash.now[:care_relationship_errors] << "そのメールアドレスのユーザーは存在しません" if caregiver.nil?
      flash.now[:care_relationship_errors] << "子どもが見つかりません" if child.nil?
      flash.now[:open_modal] = 'addCareRelationshipModal'
      render 'homes/index', status: :unprocessable_entity
    end
  end

  def update
    @care_relationship = CareRelationship.find(params[:id])
    new_status = @care_relationship.ongoing? ? :ended : :ongoing

    if @care_relationship.update(status: CareRelationship.statuses[new_status])
      flash.now[:notice] = "ステータスを『#{@care_relationship.status_i18n}』に切り替えました"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: flash[:notice] }
      end
    else
      flash.now[:alert] = "ステータスの切り替えに失敗しました"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, alert: flash[:alert] }
      end
    end
  end

  private

  def care_relationship_params
    params.require(:care_relationship).permit(:caregiver_email, :child_id)
  end

  # モーダルエラー時に homes/index を安全に再描画できるようにする
  def set_homes_data
    @children = current_user.children
    @care_relationships = CareRelationship
                          .includes(:child, :parent, :caregiver)
                          .where(parent: current_user)
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @records = Record.where(child: @children).where(recorded_at: @selected_date.all_day)
    @record = Record.new
    @next_task = "ミルク" # 必要に応じてロジックに置き換えてOK
    @routine = [
      { time: "08:00", task: "ミルク" },
      { time: "09:00", task: "睡眠" },
      { time: "11:00", task: "排泄" }
    ]
  end
end