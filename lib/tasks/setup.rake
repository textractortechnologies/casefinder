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
    source_type_custom_nlp_suggestion = Abstractor::AbstractorAbstractionSourceType.where(name: 'custom nlp suggestion').first
    indirect_source_type = Abstractor::AbstractorAbstractionSourceType.where(name: 'indirect').first

    primary_cancer_group  = Abstractor::AbstractorSubjectGroup.where(name: 'Primary Cancer', enable_workflow_status: true, workflow_status_submit: 'Submit to METRIQ',  workflow_status_pend: 'Remove from METRIQ').first_or_create
    abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(
      predicate: 'has_cancer_histology',
      display_name: 'Histology',
      abstractor_object_type: list_object_type,
      preferred_name: 'cancer histology').first_or_create

    histologies = CSV.new(File.open('lib/setup/data/ICD-O Codes Updated 1.14.15.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    histologies.each do |histology|
      if histology.to_hash['Canonical?'] == 'TRUE'
        abstractor_object_value = Abstractor::AbstractorObjectValue.where(:value => "#{histology.to_hash['Term'].downcase} (#{histology.to_hash['Code']})".downcase, vocabulary_code: histology.to_hash['Code'], vocabulary: 'ICD-O-3', vocabulary_version: '2011 Updates to ICD-O-3', properties: { type: histology.to_hash['Type'], select_for: histology.to_hash['Select for']}.to_json).first_or_create
        Abstractor::AbstractorAbstractionSchemaObjectValue.where(abstractor_abstraction_schema: abstractor_abstraction_schema,abstractor_object_value: abstractor_object_value).first_or_create
        Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => histology.to_hash['Term'].downcase).first_or_create

        normalized_values = normalize(histology.to_hash['Term'].downcase)
        normalized_values.each do |normalized_value|
          if !object_value_exists?(abstractor_abstraction_schema, normalized_value)
            Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => normalized_value.downcase).first_or_create
          end
        end
      else
        abstractor_object_value = Abstractor::AbstractorObjectValue.where(vocabulary_code: histology.to_hash['Code'], vocabulary: 'ICD-O-3', vocabulary_version: '2011 Updates to ICD-O-3').first
        Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => histology.to_hash['Term'].downcase).first_or_create
        normalized_values = normalize(histology.to_hash['Term'].downcase)
        normalized_values.each do |normalized_value|
          if !object_value_exists?(abstractor_abstraction_schema, normalized_value)
            Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => normalized_value.downcase).first_or_create
          end
        end
      end
    end

    abstractor_subject = Abstractor::AbstractorSubject.where(:subject_type => 'PathologyCase', :abstractor_abstraction_schema => abstractor_abstraction_schema).first_or_create
    Abstractor::AbstractorAbstractionSource.where(abstractor_subject: abstractor_subject, from_method: 'note', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_nlp_suggestion).first_or_create
    # Abstractor::AbstractorAbstractionSource.where(abstractor_subject: abstractor_subject, from_method: 'note', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_custom_nlp_suggestion, custom_nlp_provider: 'health_heritage_casefinder_nlp_service').first_or_create
    Abstractor::AbstractorSubjectGroupMember.where(:abstractor_subject => abstractor_subject, :abstractor_subject_group => primary_cancer_group, :display_order => 1).first_or_create

    abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(
      predicate: 'has_cancer_site',
      display_name: 'Site',
      abstractor_object_type: list_object_type,
      preferred_name: 'cancer site').first_or_create

    sites = CSV.new(File.open('lib/setup/data/icdo3_sites.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    sites.each do |site|
      abstractor_object_value = Abstractor::AbstractorObjectValue.where(:value => "#{site.to_hash['name']} (#{site.to_hash['icdo3_code']})".downcase, vocabulary_code: site.to_hash['icdo3_code'], vocabulary: 'ICD-O-3', vocabulary_version: '2011 Updates to ICD-O-3').first_or_create
      Abstractor::AbstractorAbstractionSchemaObjectValue.where(abstractor_abstraction_schema: abstractor_abstraction_schema, abstractor_object_value: abstractor_object_value).first_or_create
      Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => site.to_hash['name'].downcase).first_or_create
      site_synonyms = CSV.new(File.open('lib/setup/data/icdo3_site_synonyms.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
      site_synonyms.select { |site_synonym| site.to_hash['icdo3_code'] == site_synonym.to_hash['icdo3_code'] }.each do |site_synonym|
        Abstractor::AbstractorObjectValueVariant.where(:abstractor_object_value => abstractor_object_value, :value => site_synonym.to_hash['synonym_name'].downcase).first_or_create
      end
    end

    abstractor_subject = Abstractor::AbstractorSubject.where(:subject_type => 'PathologyCase', :abstractor_abstraction_schema => abstractor_abstraction_schema).first_or_create
    Abstractor::AbstractorAbstractionSource.where(abstractor_subject: abstractor_subject, from_method: 'note', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_nlp_suggestion).first_or_create
    # Abstractor::AbstractorAbstractionSource.where(abstractor_subject: abstractor_subject, from_method: 'note', :abstractor_rule_type => value_rule, abstractor_abstraction_source_type: source_type_custom_nlp_suggestion, custom_nlp_provider: 'health_heritage_casefinder_nlp_service').first_or_create
    Abstractor::AbstractorSubjectGroupMember.where(:abstractor_subject => abstractor_subject, :abstractor_subject_group => primary_cancer_group, :display_order => 2).first_or_create
  end

  desc "Setup pathology cases"
  task(pathology_cases: :environment) do  |t, args|
    pathology_cases = YAML.load(ERB.new(File.read("lib/setup/data/pathology_cases.yml")).result)
    pathology_cases.each do |pathology_case_file|
      pathology_case = PathologyCase.where(accession_number: pathology_case_file['accession_number'], encounter_date: pathology_case_file['encounter_date'], note: pathology_case_file['note'], patient_last_name: 'Baines', patient_first_name: 'Harold', mrn: '11111111', birth_date: '7/4/1976').first_or_create
      pathology_case.abstract
    end
  end

  desc "Setup Users"
  task(users: :environment) do  |t, args|
    user = User.where(email: 'michaeljamesgurley@gmail.com').first_or_create
    user.password = 'password'
    user.save!
  end
end

def normalize(value)
  normalized_values = []
  words = value.split(',').map(&:strip) - ['nos']
  if words.size == 1
    normalized_values << words.first
  end
  if words.size > 1
    normalized_values << words.reverse.join(' ')
    normalized_values <<  words.join(' ')
  end
  normalized_values
end

def object_value_exists?(abstractor_abstraction_schema, value)
  (Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where('abstractor_abstraction_schema_object_values.abstractor_abstraction_schema_id = ? AND lower(abstractor_object_values.value) = ?', abstractor_abstraction_schema.id, value.downcase).any?  || Abstractor::AbstractorObjectValueVariant.joins(abstractor_object_value: :abstractor_abstraction_schema_object_values).where('abstractor_abstraction_schema_object_values.abstractor_abstraction_schema_id = ? AND lower(abstractor_object_value_variants.value) = ?', abstractor_abstraction_schema.id, value.downcase).any?)
end