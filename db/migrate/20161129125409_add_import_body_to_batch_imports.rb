class AddImportBodyToBatchImports < ActiveRecord::Migration
  def change
    add_column :batch_imports, :import_body, :text
  end
end
