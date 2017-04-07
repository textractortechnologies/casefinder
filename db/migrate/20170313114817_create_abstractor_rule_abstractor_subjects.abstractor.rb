class CreateAbstractorRuleAbstractorSubjects < ActiveRecord::Migration
  def change
    create_table :abstractor_rule_abstractor_subjects do |t|
      t.integer :abstractor_rule_id,                  null: false
      t.integer :abstractor_subject_id,               null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
