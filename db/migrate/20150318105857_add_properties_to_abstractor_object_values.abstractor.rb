# This migration comes from abstractor (originally 20150317172523)
class AddPropertiesToAbstractorObjectValues < ActiveRecord::Migration
  def change
    add_column :abstractor_object_values, :properties, :text
  end
end
