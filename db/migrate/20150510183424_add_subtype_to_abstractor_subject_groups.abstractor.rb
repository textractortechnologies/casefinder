# This migration comes from abstractor (originally 20150423045055)
class AddSubtypeToAbstractorSubjectGroups < ActiveRecord::Migration
  def change
    add_column :abstractor_subject_groups, :subtype, :string
  end
end
