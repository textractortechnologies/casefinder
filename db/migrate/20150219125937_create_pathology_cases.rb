class CreatePathologyCases < ActiveRecord::Migration
  def change
    create_table :pathology_cases do |t|
      t.string      :accession_number,      null: true
      t.string      :patient_last_name,     null: false
      t.string      :patient_first_name,    null: false
      t.string      :patient_middle_name,   null: true
      t.string      :mrn,                   null: false
      t.string      :ssn,                   null: true
      t.date        :birth_date,            null: false
      t.string      :street1,               null: true
      t.string      :street2,               null: true
      t.string      :city,                  null: true
      t.string      :state,                 null: true
      t.string      :zip_code,              null: true
      t.string      :country,               null: true
      t.string      :home_phone,            null: true
      t.string      :sex,                   null: true
      t.string      :race,                  null: true
      t.date        :collection_date,       null: false
      t.string      :attending,             null: true
      t.string      :surgeon,               null: true
      t.text        :note,                  null: false
      t.timestamps
    end
  end
end