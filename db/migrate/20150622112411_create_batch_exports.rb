class CreateBatchExports < ActiveRecord::Migration
  def change
    create_table :batch_exports do |t|
      t.datetime :exported_at, null: false
      t.timestamps
    end

    create_table :batch_export_details do |t|
      t.integer :batch_export_id, null: false
      t.integer :abstractor_abstraction_group_id, null: false
      t.timestamps
    end
  end
end