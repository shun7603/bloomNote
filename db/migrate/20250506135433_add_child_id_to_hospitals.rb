class AddChildIdToHospitals < ActiveRecord::Migration[7.1]
  def change
    add_reference :hospitals, :child, null: false, foreign_key: true
  end
end
