class RenameBirthDataToBirthDateInChildren < ActiveRecord::Migration[7.1]
  def change
    rename_column :children, :birth_data, :birth_date
  end
end