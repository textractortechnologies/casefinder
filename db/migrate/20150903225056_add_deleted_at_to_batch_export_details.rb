class AddDeletedAtToBatchExportDetails < ActiveRecord::Migration
  def change
    add_column :batch_export_details, :deleted_at, :datetime
  end
end