require 'csv'
namespace :setup do
  desc "Abstractor schemas"
  task(abstractor_schemas: :environment) do  |t, args|
    list_object_type = Abstractor::AbstractorObjectType.where(value: 'list').first
    boolean_object_type = Abstractor::AbstractorObjectType.where(value: 'boolean').first
    string_object_type = Abstractor::AbstractorObjectType.where(value: 'string').first
    number_object_type = Abstractor::AbstractorObjectType.where(value: 'number').first
    radio_button_list_object_type = Abstractor::AbstractorObjectType.where(value: 'radio button list').first
    dynamic_list_object_type = Abstractor::AbstractorObjectType.where(value: 'dynamic list').first
    name_value_rule = Abstractor::AbstractorRuleType.where(name: 'name/value').first
    value_rule = Abstractor::AbstractorRuleType.where(name: 'value').first
    unknown_rule = Abstractor::AbstractorRuleType.where(name: 'unknown').first
    source_type_nlp_suggestion = Abstractor::AbstractorAbstractionSourceType.where(name: 'nlp suggestion').first
    custom_suggestion_source_type = Abstractor::AbstractorAbstractionSourceType.where(name: 'custom suggestion').first
    indirect_source_type = Abstractor::AbstractorAbstractionSourceType.where(name: 'indirect').first
    
    cancer_diagnosis_group  = Abstractor::AbstractorSubjectGroup.create(:name => 'Cancer Diagnosis')
    abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(
      predicate: 'has_cancer_histology',
      display_name: 'Cancer Histology',
      abstractor_object_type: list_object_type,
      preferred_name: 'cancer histology').first_or_create

    histologies = CSV.new(File.open('lib/setup/data/icdo3_diagnoses.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")    
    histologies.each do |histology|
      abstractor_object_value = Abstractor::AbstractorObjectValue.create(:value => "#{histology.to_hash['name']} (#{histology.to_hash['icdo3_code']})")
      Abstractor::AbstractorAbstractionSchemaObjectValue.where(abstractor_abstraction_schema: abstractor_abstraction_schema,abstractor_object_value: abstractor_object_value).first_or_create
      Abstractor::AbstractorObjectValueVariant.create(:abstractor_object_value => abstractor_object_value, :value => histology.to_hash['name'])      
      histology_synonyms = CSV.new(File.open('lib/setup/data/icdo3_diagnosis_synonyms.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")      
      histology_synonyms.select { |histology_synonym| histology.to_hash['icdo3_code'] == histology_synonym.to_hash['icdo3_code'] }.each do |histology_synonym|
        Abstractor::AbstractorObjectValueVariant.create(:abstractor_object_value => abstractor_object_value, :value => histology_synonym.to_hash['synonym_name'])
      end          
    end

    abstractor_subject = Abstractor::AbstractorSubject.create(:subject_type => 'PathologyCase', :abstractor_abstraction_schema => abstractor_abstraction_schema)
    Abstractor::AbstractorAbstractionSource.create(abstractor_subject: abstractor_subject, from_method: 'note_text', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_nlp_suggestion)
    Abstractor::AbstractorSubjectGroupMember.create(:abstractor_subject => abstractor_subject, :abstractor_subject_group => cancer_diagnosis_group, :display_order => 1)
    
    abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(
      predicate: 'has_cancer_site',
      display_name: 'Cancer Site',
      abstractor_object_type: list_object_type,
      preferred_name: 'cancer site').first_or_create


    sites = CSV.new(File.open('lib/setup/data/icdo3_sites.csv'), headers: true, col_sep: ",", return_headers: true,  quote_char: "\"")
    site_synonyms = CSV.new(File.open('lib/setup/data/icdo3_site_synonyms.csv'), headers: true, col_sep: ",", return_headers: true,  quote_char: "\"")
    sites.each do |site|
      abstractor_object_value = Abstractor::AbstractorObjectValue.create(:value => "#{site.to_hash['name']} (#{site.to_hash['icdo3_code']})")
      Abstractor::AbstractorAbstractionSchemaObjectValue.where(abstractor_abstraction_schema: abstractor_abstraction_schema,abstractor_object_value: abstractor_object_value).first_or_create
      Abstractor::AbstractorObjectValueVariant.create(:abstractor_object_value => abstractor_object_value, :value => site.to_hash['name'])      
      site_synonyms.select { |site_synonym| site.to_hash['icdo3_code'] == site_synonym.to_hash['icdo3_code'] }.each do |site_synonym|
        Abstractor::AbstractorObjectValueVariant.create(:abstractor_object_value => abstractor_object_value, :value => site_synonym.to_hash['synonym_name'])
      end          
    end

    abstractor_subject = Abstractor::AbstractorSubject.create(:subject_type => 'PathologyCase', :abstractor_abstraction_schema => abstractor_abstraction_schema)
    Abstractor::AbstractorAbstractionSource.create(abstractor_subject: abstractor_subject, from_method: 'note_text', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_nlp_suggestion)
    Abstractor::AbstractorSubjectGroupMember.create(:abstractor_subject => abstractor_subject, :abstractor_subject_group => cancer_diagnosis_group, :display_order => 2)    
  end

  desc "Setup pathology cases"
  task(pathology_cases: :environment) do  |t, args|
    pathology_cases = YAML.load(ERB.new(File.read("lib/setup/data/pathology_cases.yml")).result)
    pathology_cases.each do |pathology_case_file|
      pathology_case = PathologyCase.where(accession_number: pathology_case_file['accession_number'], collection_date: pathology_case_file['collection_date'], patient_id: pathology_case_file['patient_id'], note_text: pathology_case_file['note_text']).first_or_create
      pathology_case.abstract
    end
  end
end