class CreateBatchImports < ActiveRecord::Migration
  def change
    create_table :batch_imports do |t|
      t.datetime :imported_at, null: false
      t.string :import_file, null: true
      t.timestamps
    end
  end
end