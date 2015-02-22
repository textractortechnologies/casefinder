class CreatePathologyCases < ActiveRecord::Migration
  def change
    create_table :pathology_cases do |t|
      t.string      :accession_number,    null: false
      t.date        :collection_date,     null: false
      t.text        :note_text,           null: false
      t.integer     :patient_id,          null: false
      t.timestamps
    end
  end
end