class BatchExport < ActiveRecord::Base
  has_many :batch_export_details
  def self.find_exportable_primary_cancer_abstractor_abstraction_groups(options={})
    subject_group_primary_cancer = Abstractor::AbstractorSubjectGroup.where(name: 'Primary Cancer').first
    abstractor_subject_has_cancer_histology = Abstractor::AbstractorSubject.where(abstractor_abstraction_schema_id: Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first).first
    abstractor_subject_has_cancer_site = Abstractor::AbstractorSubject.where(abstractor_abstraction_schema_id: Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first).first
    if options[:sort_column] &&  options[:sort_direction]
      sort = options[:sort_column] + ' ' + options[:sort_direction] + ', pathology_cases.id ASC'
    else
      sort = 'pathology_cases.id ASC'
    end

    Abstractor::AbstractorAbstractionGroup.not_deleted.where('histology.abstractor_subject_id = ? AND site.abstractor_subject_id = ? AND abstractor_subject_group_id = ? AND NOT EXISTS(SELECT 1 FROM abstractor_abstractions JOIN abstractor_abstraction_group_members ON abstractor_abstractions.id = abstractor_abstraction_group_members.abstractor_abstraction_id WHERE abstractor_abstractions.deleted_at IS NULL AND abstractor_abstractions.workflow_status != ? AND abstractor_abstraction_group_members.abstractor_abstraction_group_id = abstractor_abstraction_groups.id) AND NOT EXISTS(SELECT 1 FROM batch_export_details WHERE batch_export_details.deleted_at IS NULL AND abstractor_abstraction_groups.id = batch_export_details.abstractor_abstraction_group_id)', abstractor_subject_has_cancer_histology.id, abstractor_subject_has_cancer_site.id, subject_group_primary_cancer.id, Abstractor::Enum::ABSTRACTION_WORKFLOW_STATUS_SUBMITTED).joins("JOIN pathology_cases ON abstractor_abstraction_groups.about_id = pathology_cases.id AND abstractor_abstraction_groups.about_type = 'PathologyCase' JOIN abstractor_abstraction_group_members ON abstractor_abstraction_groups.id = abstractor_abstraction_group_members.abstractor_abstraction_group_id JOIN abstractor_abstractions AS histology ON abstractor_abstraction_group_members.abstractor_abstraction_id = histology.id AND histology.deleted_at IS NULL JOIN abstractor_abstraction_group_members site_group_member ON abstractor_abstraction_groups.id = site_group_member.abstractor_abstraction_group_id JOIN abstractor_abstractions AS site ON site_group_member.abstractor_abstraction_id = site.id AND site.deleted_at IS NULL").select('abstractor_abstraction_groups.*, pathology_cases.accession_number, pathology_cases.collection_date, histology.value AS histology, site.value AS site').order(sort)
  end

  def load_primary_cancer_abstractor_abstraction_groups(options={})
    abstractor_subject_has_cancer_histology = Abstractor::AbstractorSubject.where(abstractor_abstraction_schema_id: Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first).first
    abstractor_subject_has_cancer_site = Abstractor::AbstractorSubject.where(abstractor_abstraction_schema_id: Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first).first
    if options[:sort_column] &&  options[:sort_direction]
      sort = options[:sort_column] + ' ' + options[:sort_direction] + ', pathology_cases.id ASC'
    else
      sort = 'pathology_cases.id ASC'
    end

    Abstractor::AbstractorAbstractionGroup.not_deleted.where('batch_export_details.deleted_at IS NULL AND histology.workflow_status = ? AND site.workflow_status = ? AND histology.abstractor_subject_id = ? AND site.abstractor_subject_id = ? AND batch_export_details.batch_export_id = ?', Abstractor::Enum::ABSTRACTION_WORKFLOW_STATUS_SUBMITTED, Abstractor::Enum::ABSTRACTION_WORKFLOW_STATUS_SUBMITTED, abstractor_subject_has_cancer_histology.id, abstractor_subject_has_cancer_site.id, self.id).joins("JOIN batch_export_details ON abstractor_abstraction_groups.id = batch_export_details.abstractor_abstraction_group_id JOIN pathology_cases ON abstractor_abstraction_groups.about_id = pathology_cases.id AND abstractor_abstraction_groups.about_type = 'PathologyCase' JOIN abstractor_abstraction_group_members ON abstractor_abstraction_groups.id = abstractor_abstraction_group_members.abstractor_abstraction_group_id JOIN abstractor_abstractions AS histology ON abstractor_abstraction_group_members.abstractor_abstraction_id = histology.id AND histology.deleted_at IS NULL JOIN abstractor_abstraction_group_members site_group_member ON abstractor_abstraction_groups.id = site_group_member.abstractor_abstraction_group_id JOIN abstractor_abstractions AS site ON site_group_member.abstractor_abstraction_id = site.id AND site.deleted_at IS NULL").select('abstractor_abstraction_groups.*, pathology_cases.accession_number, pathology_cases.collection_date, histology.value AS histology, site.value AS site').order(sort)
  end

  def self.to_metriq(abstractor_abstraction_groups)
    MetriqDocument.new(abstractor_abstraction_groups).generate
  end
end