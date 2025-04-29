class CreateCareRelationships < ActiveRecord::Migration[7.1]
  def change
    create_table :care_relationships do |t|
      t.references :parent, null: false, foreign_key: {to_table: users}
      t.references :caregiver, null: false, foreign_key: {to_table: users}
      t.references :child, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
