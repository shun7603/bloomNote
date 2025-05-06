# db/migrate/xxxxxx_change_routine_time_to_time.rb
class ChangeRoutineTimeToTime < ActiveRecord::Migration[7.1]
  def change
    change_column :routines, :time, :time
  end
end