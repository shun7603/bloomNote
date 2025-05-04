class RoutinesController < ApplicationController
  before_action :set_child
  def index
    @children = current_user.children.includes(:routines)
    @selected_date = params[:date]&.to_date || Date.current
    @records = Record.where(recorded_at: @selected_date.all_day)

    @care_relationships = current_user.care_relationships.includes(:child, :parent, :caregiver)
  end

  def create
    @routine = @child.routines.build(routine_params)
    if @routine.save
      flash[:notice] = "ルーティンを登録しました"
      redirect_to root_path
    else
      flash[:alert] = "ルーティン登録に失敗しました"
      flash[:routine_errors] = @routine.errors.full_messages
      flash[:open_modal] = "routineModal"
      redirect_to root_path
    end
  end

  private

  def set_child
    @child = Child.find(params[:child_id])
  end

  def routine_params
    params.require(:routine).permit(:time, :task, :category, :memo, :photo)
  end
end