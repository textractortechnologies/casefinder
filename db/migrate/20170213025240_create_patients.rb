class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :patient_id
      t.string  :mrn
      t.string  :cpi
      t.timestamps
    end
    add_index :patients, [:cpi], name: "index_patients__cpi"
  end
end
