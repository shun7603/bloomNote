class CareRelationshipsController < ApplicationController
  before_action :set_children_and_users, only: [:new, :create, :index]

  def index
    @care_relationships = CareRelationship.includes(:parent, :caregiver, :child)
  end

  def new
    @care_relationship = CareRelationship.new
  end

  def create
    caregiver = User.find_by(email: params[:care_relationship][:caregiver_email])
    child = Child.find_by(id: params[:care_relationship][:child_id])
    @children = current_user.children

    if caregiver && child
      care_relationship = CareRelationship.new(
        parent_id: current_user.id,
        caregiver_id: caregiver.id,
        child_id: child.id,
        status: 0
      )

      if care_relationship.save
        redirect_to root_path, notice: "保育者を追加しました"
      else
        flash.now[:care_relationship_errors] = care_relationship.errors.full_messages
        flash.now[:open_modal] = 'addCareRelationshipModal'
        render 'homes/index', status: :unprocessable_entity
      end
    else
      flash.now[:care_relationship_errors] = ["そのメールアドレスのユーザーは存在しません"] if caregiver.nil?
      flash.now[:care_relationship_errors] ||= []
      flash.now[:care_relationship_errors] << "子どもが見つかりません" if child.nil?
      flash.now[:open_modal] = 'addCareRelationshipModal'
      render 'homes/index', status: :unprocessable_entity
    end
  end

  def update
    @care_relationship = CareRelationship.find(params[:id])
    if @care_relationship.update(status: params[:status])
      redirect_to care_relationships_path, notice: "ステータスを更新しました"
    else
      redirect_to care_relationships_path, alert: "ステータス更新に失敗しました"
    end
  end

  private

  def care_relationship_params
    params.require(:care_relationship).permit(:parent_id, :caregiver_id, :child_id, :status)
  end

  def set_children_and_users
    @children = Child.all
    @users = User.all
  end
end