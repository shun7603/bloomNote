class AddCategoryToRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :category, :string
  end
end
