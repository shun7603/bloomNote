class RemoveCategoryFromRoutines < ActiveRecord::Migration[7.1]
  def change
    remove_column :routines, :category, :string
  end
end
