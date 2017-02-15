class CreateBatchImportOrders < ActiveRecord::Migration
  def change
    create_table :batch_import_orders do |t|
      t.datetime :imported_at, null: false
      t.text :import_body, null: false
      t.text :status, null: true
      t.integer :patient_id
      t.timestamps
    end
  end
end