# This migration comes from abstractor (originally 20140803205149)
class AddCustomExplanationToAbstractorSuggestionSources < ActiveRecord::Migration
  def change
    add_column :abstractor_suggestion_sources, :custom_explanation, :string
  end
end
