class AddUserIdToRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :user_id, :bigint
  end
end
