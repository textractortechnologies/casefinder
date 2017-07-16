# This migration comes from abstractor (originally 20170704123235)
class AddNameToAbstractorRules < ActiveRecord::Migration
  def change
    add_column :abstractor_rules, :name, :string
  end
end
