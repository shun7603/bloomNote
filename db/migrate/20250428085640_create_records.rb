class CreateRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :records do |t|
      t.references :child, null: false, foreign_key: true
      t.integer :record_type
      t.integer :quantity
      t.text :memo
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
