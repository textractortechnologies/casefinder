# This migration comes from abstractor (originally 20140716184049)
class AddDynamicListMethodToAbstractorSubjects < ActiveRecord::Migration
  def change
    add_column :abstractor_subjects, :dynamic_list_method, :string
  end
end