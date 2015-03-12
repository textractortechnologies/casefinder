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
      t.string      :address_line_1,        null: true
      t.string      :address_line_2,        null: true
      t.string      :city,                  null: true
      t.string      :state,                 null: true
      t.string      :zip_code,              null: true
      t.string      :home_phone,            null: true
      t.string      :gender,                null: true
      t.date        :encounter_date,        null: false
      t.text        :note,                  null: false
      t.timestamps
    end
  end
end
# last_name
# first_name
# middle_name
# pat_mrn_id
# ssn
# birth_date
# addr_line_1
# addr_line_2
# city
# state_code
# zip_code
# home_phone
# gender_code
# enc_date
# ord_res_comp_comment