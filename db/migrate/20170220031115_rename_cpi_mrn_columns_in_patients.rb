class RenameCpiMrnColumnsInPatients < ActiveRecord::Migration
  def change
    remove_index :patients, name: "index_patients__cpi"
    rename_column :patients, :cpi, :cpi_mrn
    rename_column :patients, :mrn, :cpi
    rename_column :patients, :cpi_mrn, :mrn
    add_index :patients, [:mrn], name: "index_patients__mrn"
  end
end
