class ChildrenController < ApplicationController
  before_action :authenticate_user!

  def index
    @children = Child
                .left_joins(:care_relationships)
                .where(
                  "children.user_id = :user_id OR (care_relationships.caregiver_id = :user_id AND care_relationships.status = :ongoing)",
                  user_id: current_user.id,
                  ongoing: CareRelationship.statuses[:ongoing]
                )
                .distinct
                .includes(:routines)

    @routine = [
      { time: '08:00', task: 'ミルク' },
      { time: '09:00', task: '睡眠' },
      { time: '11:00', task: '排泄' }
    ]
  end

  def show
    @child = current_user.children.find(params[:id])

    @routine = [
      { time: '08:00', task: 'ミルク' },
      { time: '09:00', task: '睡眠' },
      { time: '11:00', task: '排泄' }
    ]
  end

  def new
    @child = Child.new
  end

  def select
    child = Child.find_by(id: params[:id])

    if child && current_user.can_access?(child)
      session[:selected_child_id] = child.id
      flash[:notice] = "#{child.name} を選択しました"
    else
      flash[:alert] = "その子どもにはアクセスできません"
    end

    redirect_to root_path
  end

  def create
    @child = current_user.children.build(child_params)

    if @child.save
      redirect_to root_path, notice: '子どもを登録しました'
    else
      flash[:child_new_errors] = @child.errors.full_messages
      flash[:child_attributes] = child_params
      flash[:child_modal_error] = "new"
      redirect_to root_path
    end
  end

  def update
    @child = current_user.children.find_by(id: params[:id])

    redirect_to root_path, alert: '更新権限がありません' and return unless @child

    if @child.update(child_params)
      redirect_to root_path, notice: '子ども情報を更新しました'
    else
      flash[:child_edit_errors] = @child.errors.full_messages
      flash[:child_modal_error] = "edit"
      flash[:child_attributes] = child_params
      redirect_to root_path
    end
  end

  def destroy
    @child = current_user.children.find_by(id: params[:id])

    if @child&.destroy
      session.delete(:selected_child_id) if session[:selected_child_id] == @child.id
      redirect_to root_path, notice: "#{@child.name} の情報を削除しました"
    else
      redirect_to root_path, alert: "子どもの削除に失敗しました"
    end
  end

  private

  def child_params
    params.require(:child).permit(:name, :birth_date, :gender)
  end
end