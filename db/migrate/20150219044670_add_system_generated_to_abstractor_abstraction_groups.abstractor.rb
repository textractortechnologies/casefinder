# This migration comes from abstractor (originally 20141120044606)
class AddSystemGeneratedToAbstractorAbstractionGroups < ActiveRecord::Migration
  def change
    add_column :abstractor_abstraction_groups, :system_generated, :boolean, default: false
  end
end
