class MetriqDocument < Fixy::Document
  attr_accessor :pathology_cases
  def initialize(pathology_cases)
    @pathology_cases = pathology_cases
  end

  def build
    pathology_cases.each do |pathology_case|
      pathology_case.with_cancer_histologies.joins('JOIN abstractor_object_values aov ON has_cancer_site = aov.value JOIN abstractor_abstraction_schema_object_values aasov ON aov.id = aasov.abstractor_object_value_id').select('pathology_cases.*, aov.vocabulary_code, aov.vocabulary, aov.vocabulary_version').each do |site|
        append_record MetriqRecord.new(pathology_case.patient_last_name, pathology_case.patient_first_name, site.vocabulary_code, pathology_case.mrn, pathology_case.ssn, pathology_case.addr_no_and_street, pathology_case.city, pathology_case.state, pathology_case.zip_code, pathology_case.home_phone, pathology_case.birth_date, pathology_case.gender)
      end
    end
  end
end