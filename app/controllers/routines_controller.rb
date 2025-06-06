class RoutinesController < ApplicationController
  before_action :set_child

  def index
    @children = current_user.children.includes(:routines)
    @selected_date = params[:date]&.to_date || Date.current
    @records = Record.where(recorded_at: @selected_date.all_day)
    @care_relationships = current_user.care_relationships.includes(:child, :parent, :caregiver)

    # 今やるべきルーティンの表示用処理
    current_time = Time.current
    routines = @child.routines.order(:time)
    recorded_types = Record.where(child_id: @child.id, recorded_at: current_time.all_day).pluck(:record_type)

    next_routine = routines.find do |routine|
      routine_time_today = Time.zone.parse("#{current_time.to_date} #{routine.time.strftime('%H:%M')}")
      routine_time_today <= current_time && !recorded_types.include?(routine.task)
    end

    if next_routine
      @next_routine_time = next_routine.time.strftime('%H:%M')
      @next_routine_task = Routine.tasks[next_routine.task]
      @next_task = I18n.t("activerecord.attributes.record.record_type.#{next_routine.task}")
    else
      @next_routine_time = nil
      @next_routine_task = nil
      @next_task = nil
    end
  end

  def create
    @routine = @child.routines.build(routine_params)
    if @routine.save
      flash[:notice] = "ルーティンを登録しました"
    else
      flash[:alert] = "ルーティン登録に失敗しました"
      flash[:routine_errors] = @routine.errors.full_messages
      flash[:routine_attributes] = routine_params.to_h
      flash[:routine_modal_error] = true # ← モーダル再表示用
    end
    redirect_to root_path
  end

  # app/controllers/routines_controller.rb
  def update
    @routine = @child.routines.find(params[:id])
    if @routine.update(routine_params)
      redirect_to root_path, notice: "ルーティンを更新しました"
    else
      flash[:routine_errors] = @routine.errors.full_messages
      flash[:routine_attributes] = routine_params.to_h
      flash[:routine_modal_error] = @routine.id # ← ここを追加
      redirect_to root_path
    end
  end

  def destroy
    @routine = @child.routines.find(params[:id])
    @routine.destroy
    flash[:notice] = "ルーティンを削除しました"
    redirect_to root_path
  end

  private

  def set_child
    @child = Child.find(params[:child_id])
  end

  def routine_params
    params.require(:routine).permit(:time, :task, :memo, :photo)
  end
end