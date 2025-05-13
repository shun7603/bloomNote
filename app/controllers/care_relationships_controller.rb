class CareRelationshipsController < ApplicationController
  before_action :set_homes_data, only: [:create]

  def create
    caregiver = User.find_by(email: care_relationship_params[:caregiver_email])
    child = Child.find_by(id: care_relationship_params[:child_id])

    if caregiver && child
      # すでに同じ関係が存在するか確認
      existing = CareRelationship.find_by(
        parent: current_user,
        caregiver: caregiver,
        child: child,
        status: :ongoing
      )

      if existing
        flash[:care_relationship_errors] = ["この保育者とはすでに関係が登録されています"]
        flash[:open_modal] = "addCareRelationshipModal"
        redirect_to root_path and return
      end

      care_relationship = CareRelationship.new(
        parent: current_user,
        caregiver: caregiver,
        child: child,
        status: :ongoing
      )

      if care_relationship.save
        @care_relationship = care_relationship

        respond_to do |format|
          format.turbo_stream
          redirect_to root_path, notice: "保育者を追加しました"
        end
      else
        flash[:care_relationship_errors] = care_relationship.errors.full_messages
        flash[:open_modal] = "addCareRelationshipModal"
        redirect_to root_path
      end
    else
      flash[:care_relationship_errors] = []
      flash[:care_relationship_errors] << "そのメールアドレスのユーザーは存在しません" if caregiver.nil?
      flash[:care_relationship_errors] << "子どもが見つかりません" if child.nil?
      flash[:open_modal] = "addCareRelationshipModal"
      redirect_to root_path
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

  # app/controllers/care_relationships_controller.rb
  def destroy
    @care_relationship = CareRelationship.find(params[:id])
    if @care_relationship.destroy
      redirect_to root_path, notice: "関係を削除しました"
    else
      redirect_to root_path, alert: "削除できませんでした"
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