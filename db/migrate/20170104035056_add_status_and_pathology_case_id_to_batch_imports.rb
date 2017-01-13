class AddStatusAndPathologyCaseIdToBatchImports < ActiveRecord::Migration
  def change
    add_column :batch_imports, :pathology_case_id, :integer
    add_column :batch_imports, :status, :text
  end
end
