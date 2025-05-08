class RenameBirthDataToBirthDateInChildren < ActiveRecord::Migration[7.1]
  def change
    return unless column_exists?(:children, :birth_data)

    rename_column :children, :birth_data, :birth_date
  end
end