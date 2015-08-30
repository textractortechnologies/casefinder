class MetriqDocument < Fixy::Document
  attr_accessor :abstractor_abstraction_groups
  def initialize(abstractor_abstraction_groups)
    @abstractor_abstraction_groups = abstractor_abstraction_groups
  end

  def build
    abstraction_schema_has_cancer_site = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first
    abstraction_schema_has_cancer_histology = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first
    abstractor_abstraction_groups.each do |abstractor_abstraction_group|
      site = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where('abstractor_abstraction_schema_object_values.abstractor_abstraction_schema_id = ? AND abstractor_object_values.value = ? AND abstractor_object_values.deleted_at IS NULL', abstraction_schema_has_cancer_site.id, abstractor_abstraction_group.about.abstractor_abstractions_by_abstraction_schemas(abstractor_abstraction_schema_ids: [abstraction_schema_has_cancer_site.id], abstractor_abstraction_group: abstractor_abstraction_group).first.value).first
      if site.nil?
        site = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where('abstractor_abstraction_schema_object_values.abstractor_abstraction_schema_id = ? AND abstractor_object_values.value = ?', abstraction_schema_has_cancer_site.id, abstractor_abstraction_group.about.abstractor_abstractions_by_abstraction_schemas(abstractor_abstraction_schema_ids: [abstraction_schema_has_cancer_site.id], abstractor_abstraction_group: abstractor_abstraction_group).first.value).first
      end
      histology = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where('abstractor_abstraction_schema_object_values.abstractor_abstraction_schema_id = ? AND abstractor_object_values.value = ? AND abstractor_object_values.deleted_at IS NULL', abstraction_schema_has_cancer_histology.id, abstractor_abstraction_group.about.abstractor_abstractions_by_abstraction_schemas(abstractor_abstraction_schema_ids: [abstraction_schema_has_cancer_histology.id], abstractor_abstraction_group: abstractor_abstraction_group).first.value).first
      if histology.nil?
        histology = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where('abstractor_abstraction_schema_object_values.abstractor_abstraction_schema_id = ? AND abstractor_object_values.value = ?', abstraction_schema_has_cancer_histology.id, abstractor_abstraction_group.about.abstractor_abstractions_by_abstraction_schemas(abstractor_abstraction_schema_ids: [abstraction_schema_has_cancer_histology.id], abstractor_abstraction_group: abstractor_abstraction_group).first.value).first
      end
      append_record MetriqRecord.new(abstractor_abstraction_group.about.patient_last_name, abstractor_abstraction_group.about.patient_first_name, site.vocabulary_code, histology.vocabulary_code, abstractor_abstraction_group.about.mrn, abstractor_abstraction_group.about.ssn, abstractor_abstraction_group.about.addr_no_and_street, abstractor_abstraction_group.about.city, abstractor_abstraction_group.about.state, abstractor_abstraction_group.about.zip_code, abstractor_abstraction_group.about.home_phone, abstractor_abstraction_group.about.birth_date, abstractor_abstraction_group.about.sex)
    end
  end
end