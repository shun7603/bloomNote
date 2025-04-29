class CreateHospitals < ActiveRecord::Migration[7.1]
  def change
    create_table :hospitals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :phone_number

      t.timestamps
    end
  end
end
