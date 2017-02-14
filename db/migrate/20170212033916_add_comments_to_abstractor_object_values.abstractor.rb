# This migration comes from abstractor (originally 20170212033728)
class AddCommentsToAbstractorObjectValues < ActiveRecord::Migration
  def change
    add_column :abstractor_object_values, :comments, :text
  end
end
