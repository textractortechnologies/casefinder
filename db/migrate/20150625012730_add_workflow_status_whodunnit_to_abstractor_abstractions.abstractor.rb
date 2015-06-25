# This migration comes from abstractor (originally 20150625011238)
class AddWorkflowStatusWhodunnitToAbstractorAbstractions < ActiveRecord::Migration
  def change
    add_column :abstractor_abstractions, :workflow_status_whodunnit, :string
  end
end
