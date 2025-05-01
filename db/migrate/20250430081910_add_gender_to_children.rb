# db/migrate/xxxx_add_gender_to_children.rb
class AddGenderToChildren < ActiveRecord::Migration[7.1]
  def change
    add_column :children, :gender, :integer, null: false, default: 0
  end
end