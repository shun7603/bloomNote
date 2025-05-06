class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @children      = Child.accessible_by(current_user)
    @selected_date = parse_date(params[:date])
    @record        = Record.new
    @current_child = current_child

    if @current_child.present?
      @records = @current_child.records
                               .where(recorded_at: @selected_date.all_day)
                               .order(recorded_at: :desc)

      @routines = @current_child.routines.order(:time)

      current_time = Time.zone.now
      @next_routine = @routines.find do |routine|
        today_time = Time.zone.local(current_time.year, current_time.month, current_time.day,
                                     routine.time.hour, routine.time.min, routine.time.sec)
        today_time > current_time
      end

      @next_task_label   = @next_routine&.task_label || "未定"
      @next_routine_time = @next_routine&.time&.strftime("%H:%M")
    else
      @records = []
      @routines = []
      @next_routine = nil
      @next_task_label = "未定"
      @next_routine_time = nil
    end

    @care_relationships = current_user.care_relationships.includes(:child, :caregiver)
  end

  private

  def parse_date(date_str)
    return Date.current if date_str.blank?

    Date.parse(date_str)
  rescue ArgumentError
    Date.current
  end
end