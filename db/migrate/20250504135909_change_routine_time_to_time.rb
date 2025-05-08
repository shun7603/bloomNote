class ChangeRoutineTimeToTime < ActiveRecord::Migration[7.1]
  def up
    if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
      change_column :routines, :time, 'time USING time::time'
    else
      change_column :routines, :time, :time
    end
  end

  def down
    change_column :routines, :time, :datetime
  end
end