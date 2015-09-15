class MetriqRecordSimple < Fixy::Record
  include Fixy::Formatter::Alphanumeric
  set_record_length 499

  def initialize(patient_last_name, patient_first_name, patient_middle_name, primary_site_icd_o_3, primary_histology_icd_o_3, medical_record_number, social_security_number, addr_no_and_street, city, state, zip_code, telephone, birth_date, sex, collection_date)
    @patient_last_name = patient_last_name
    @patient_first_name = patient_first_name
    @patient_middle_name = patient_middle_name.nil? ? '' : patient_middle_name.first
    @primary_site_icd_o_3 = primary_site_icd_o_3.blank? ? nil : primary_site_icd_o_3.gsub('.','')
    @medical_record_number = itegerify(medical_record_number)
    @social_security_number = itegerify(social_security_number)
    @addr_no_and_street = addr_no_and_street
    @city = city
    @state = state
    @zip_code = itegerify(zip_code)
    @telephone = itegerify(telephone)
    @birth_date = birth_date.blank? ? nil : birth_date.to_s.gsub('-', '/')
    @sex = map_sex(sex)
    @collection_date = collection_date.blank? ? nil : collection_date.to_s(:short_date).gsub('-', '/')
  end

  def itegerify(token)
    token.blank? ? nil : token.gsub(/\D/, '')
  end

  # 1 Male
  # 2 Female
  # 3 Other
  # 4 Transsexual
  # 9 Unknown

  def map_sex(sex)
    case sex
    when 'F'
      '2'
    when 'M'
      '1'
    else
      nil
    end
  end

  field :hospital_id,                                       5,    '1-5' ,      :alphanumeric
  field :patient_last_name,                                20,    '6-25' ,     :alphanumeric
  field :patient_first_name,                               14,    '26-39',     :alphanumeric
  field :patient_middle_initial,                            1,    '40',        :alphanumeric
  field :medical_record_number,                            11,    '41-51',     :alphanumeric
  field :social_security_number,                            9,    '52-60',     :alphanumeric
  field :birth_date,                                       10,    '61-70',     :alphanumeric
  field :primary_site_icd_o_3,                              4,    '71-74',     :alphanumeric
  field :icd_9_cm,                                          5,    '75-79',     :alphanumeric
  field :date_of_last_contact_death,                        8,    '80-87',     :alphanumeric
  field :county,                                            3,    '88-90',     :alphanumeric
  field :addr_no_and_street,                               38,    '91-128',    :alphanumeric
  field :city,                                             15,    '129-143',   :alphanumeric
  field :state,                                             2,    '144-145',   :alphanumeric
  field :zip_code,                                          5,    '146-150',   :alphanumeric
  field :zip_code_plus_4,                                   4,    '151-154',   :alphanumeric
  field :telephone,                                        10,    '155-164',   :alphanumeric
  field :maiden_name,                                      15,    '165-179',   :alphanumeric
  field :spouse_last_name,                                 15,    '180-194',   :alphanumeric
  field :spouse_first_name,                                14,    '195-208',   :alphanumeric
  field :place_of_birth,                                    3,    '209-211',   :alphanumeric
  field :autopsy,                                           1,        '212',   :alphanumeric
  field :sex,                                               1,        '213',   :alphanumeric
  field :race1,                                             2,    '214-215',   :alphanumeric
  field :spanish_hispanic_origin,                           1,        '216',   :alphanumeric
  field :marital_status_at_diagnosis,                       1,        '217',   :alphanumeric
  field :family_history_of_cancer,                          1,        '218',   :alphanumeric
  field :tobacco_history,                                   1,        '219',   :alphanumeric
  field :alcohol_history,                                   1,        '220',   :alphanumeric
  field :follow_up_letter_language_code,                    1,        '221',   :alphanumeric
  field :lost_to_follow_up_flag,                            1,        '222',   :alphanumeric
  field :employer,                                         30,    '223-252',   :alphanumeric
  field :employer_state,                                    2,    '253-254',   :alphanumeric
  field :employers_telephone_number,                       10,    '255-264',   :alphanumeric
  field :employers_telephone_extension,                     4,    '265-268',   :alphanumeric
  field :current_or_most_recent_industry,                  16,    '269-284',   :alphanumeric
  field :longest_industry,                                 16,    '285-300',   :alphanumeric
  field :current_or_most_recent_occupation,                16,    '301-316',   :alphanumeric
  field :longest_occupation,                               16,    '317-332',   :alphanumeric
  field :comments,                                         50,    '333-382',   :alphanumeric
  field :follow_up_contact_name,                           15,    '383-397',   :alphanumeric
  field :follow_up_contact_name_2,                         14,    '398-411',   :alphanumeric
  field :secondary_contact_middle_initial,                  1,    '412',       :alphanumeric
  field :secondary_contact_street_address,                 22,    '413-434',   :alphanumeric
  field :secondary_contact_city,                           15,    '435-449',   :alphanumeric
  field :secondary_contact_state,                           2,    '450-451',   :alphanumeric
  field :secondary_contact_zip_code,                        5,    '452-456',   :alphanumeric
  field :secondary_contact_zip_plus_4_code,                 4,    '457-460',   :alphanumeric
  field :secondary_contact_telephone_number,               10,    '461-470',   :alphanumeric
  field :secondary_contact_relationship_code,               1,    '471',       :alphanumeric
  field :secondary_contact_follow_up_letter_language_code,  1,    '472',       :alphanumeric
  field :expiration_date,                                   8,    '473-480',   :alphanumeric
  field :reserved,                                         12,    '481-492',   :alphanumeric
  field :icd_10_cm,                                         7,    '493-499',   :alphanumeric

  field_value :hospital_id                                      , ''
  field_value :patient_last_name                                , -> { @patient_last_name }
  field_value :patient_first_name                               , -> { @patient_first_name }
  field_value :patient_middle_initial                           , -> { @patient_middle_name }
  field_value :medical_record_number                            , -> { @medical_record_number }
  field_value :social_security_number                           , -> { @social_security_number }
  field_value :birth_date                                       , -> { @birth_date }
  field_value :primary_site_icd_o_3                             , -> { @primary_site_icd_o_3 }
  field_value :icd_9_cm                                         , ''
  field_value :date_of_last_contact_death                       , -> { @collection_date }
  field_value :county                                           , ''
  field_value :addr_no_and_street                               , -> { @addr_no_and_street }
  field_value :city                                             , -> { @city }
  field_value :state                                            , -> { @state }
  field_value :zip_code                                         , -> { @zip_code }
  field_value :zip_code_plus_4                                  , ''
  field_value :telephone                                        , -> { @telephone }
  field_value :maiden_name                                      , ''
  field_value :spouse_last_name                                 , ''
  field_value :spouse_first_name                                , ''
  field_value :place_of_birth                                   , ''
  field_value :autopsy                                          , ''
  field_value :sex                                              , -> { @sex }
  field_value :race1                                            , ''
  field_value :spanish_hispanic_origin                          , ''
  field_value :marital_status_at_diagnosis                      , ''
  field_value :family_history_of_cancer                         , ''
  field_value :tobacco_history                                  , ''
  field_value :alcohol_history                                  , ''
  field_value :follow_up_letter_language_code                   , ''
  field_value :lost_to_follow_up_flag                           , ''
  field_value :employer                                         , ''
  field_value :employer_state                                   , ''
  field_value :employers_telephone_number                       , ''
  field_value :employers_telephone_extension                    , ''
  field_value :current_or_most_recent_industry                  , ''
  field_value :longest_industry                                 , ''
  field_value :current_or_most_recent_occupation                , ''
  field_value :longest_occupation                               , ''
  field_value :comments                                         , ''
  field_value :follow_up_contact_name                           , ''
  field_value :follow_up_contact_name_2                         , ''
  field_value :secondary_contact_middle_initial                 , ''
  field_value :secondary_contact_street_address                 , ''
  field_value :secondary_contact_city                           , ''
  field_value :secondary_contact_state                          , ''
  field_value :secondary_contact_zip_code                       , ''
  field_value :secondary_contact_zip_plus_4_code                , ''
  field_value :secondary_contact_telephone_number               , ''
  field_value :secondary_contact_relationship_code              , ''
  field_value :secondary_contact_follow_up_letter_language_code , ''
  field_value :expiration_date                                  , ''
  field_value :reserved                                         , ''
  field_value :icd_10_cm                                        , ''
end