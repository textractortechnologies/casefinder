require 'roo'
require 'csv'
require "benchmark"
class PathologyCase < ActiveRecord::Base
  include Abstractor::Abstractable
  COLLECTION_DATE_DATE_TYPE = 'collected'
  IMPORTED_DATE_DATE_TYPE = 'imported'
  DATE_TYPES = [COLLECTION_DATE_DATE_TYPE, IMPORTED_DATE_DATE_TYPE]

  scope :by_date, ->(date_type, date_from, date_to) do
    if (!date_from.blank? && !date_to.blank?)
      date_range = [date_from, date_to]
    else
      date_range = []
    end

    unless (date_range.first.blank? || date_range.last.blank?)
      case date_type
      when PathologyCase::COLLECTION_DATE_DATE_TYPE
        where("collection_date BETWEEN ? AND ?", Date.parse(date_range.first), (Date.parse(date_range.last) +1).to_s)
      when PathologyCase::IMPORTED_DATE_DATE_TYPE
        where("created_at BETWEEN ? AND ?", Date.parse(date_range.first), (Date.parse(date_range.last) +1).to_s)
      end
    end
  end

  scope :search_across_fields, ->(search_token, options={}) do
    options = { abstractor_abstraction_schemas: abstractor_abstraction_schemas, sort_column: 'collection_date', sort_direction: 'asc' }.merge(options)

    if search_token
      s = where(["lower(accession_number) like ? OR EXISTS (SELECT 1 FROM abstractor_abstractions aa JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id AND sub.abstractor_abstraction_schema_id IN (?) JOIN abstractor_suggestions sug ON aa.id = sug.abstractor_abstraction_id WHERE aa.deleted_at IS NULL AND aa.about_type = '#{self.to_s}' AND #{self.table_name}.id = aa.about_id AND sug.suggested_value like ?)", "%#{search_token}%", options[:abstractor_abstraction_schemas], "%#{search_token}%"])
    end

    joins_clause = prepare_joins_and_select_clauses(options[:sort_column], options[:sort_direction])

    if joins_clause
      options[:sort_column] = 'suggested_value'
      s = s.nil? ? joins(joins_clause) : s.joins(joins_clause)
    end

    sort = options[:sort_column] + ' ' + options[:sort_direction] + ', pathology_cases.id ASC'
    s = s.nil? ? order(sort) : s.order(sort)

    s
  end

  def self.map_abstractor_column(column)
    mapped_column = case column
    when 'suggested_histologies'
      'has_cancer_histology'
    when 'suggested_sites'
      'has_cancer_site'
    else
      nil
    end
    mapped_column
  end

  def self.prepare_joins_and_select_clauses(sort_column, sort_direction)
    joins_clause = nil
    predicate = PathologyCase.map_abstractor_column(sort_column)

    if sort_direction == 'asc'
      aggregrate = 'MIN'
    else
      aggregrate = 'MAX'
    end

    if predicate
      abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: predicate).first
      joins_clause ="
      LEFT JOIN (
      SELECT  aa.about_id
            , #{aggregrate}(sug.suggested_value) AS suggested_value
      FROM abstractor_abstractions aa JOIN abstractor_suggestions sug ON aa.id = sug.abstractor_abstraction_id AND aa.deleted_at IS NULL
                                      JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id and sub.abstractor_abstraction_schema_id = #{abstractor_abstraction_schema.id}
      GROUP BY aa.about_id
       ) AS suggestions ON suggestions.about_id = pathology_cases.id"
    end
    joins_clause
  end

  def self.to_csv(pathology_cases, options = {})
    headers = (PathologyCase.attribute_names - ['suggested_sites', 'suggested_histologies'])
    CSV.generate(options) do |csv|
      csv << headers + ['discarded?', 'suggested_sites', 'suggested_histologies']
      headers = headers - ['discarded?', 'suggested_sites', 'suggested_histologies']
      pathology_cases.each do |pathology_case|
        csv << pathology_case.attributes.values_at(*headers).concat([pathology_case.discarded?, pathology_case.suggested_sites.join('|'), pathology_case.suggested_histologies.join('|')])
      end
    end
  end

  def with_cancer_diagnoses
    PathologyCase.pivot_grouped_abstractions('Primary Cancer').where(id: id)
  end

  def suggested_histologies
    histology_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first
    abstractions = abstractor_abstractions_by_abstraction_schemas(abstractor_abstraction_schema_ids: [histology_abstraction_schema.id])
    suggestions = abstractions.map { |a| a.abstractor_suggestions }.flatten.select { |s| s.abstractor_suggestion_sources.not_deleted.any? }.map(&:suggested_value).uniq.compact.sort
  end

  def suggested_sites
    histology_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first
    abstractions = abstractor_abstractions_by_abstraction_schemas(abstractor_abstraction_schema_ids: [histology_abstraction_schema.id])
    suggestions = abstractions.map { |a| a.abstractor_suggestions }.flatten.select { |s| s.abstractor_suggestion_sources.not_deleted.any? }.map(&:suggested_value).uniq.compact.sort
  end

  def patient_full_name
    [patient_first_name.titleize, patient_middle_name.try(:titleize), patient_last_name.titleize].reject { |n| n.nil? or n.blank?  }.join(' ')
  end

  def addr_no_and_street
    [street1, street2].reject { |n| n.nil? or n.blank? }.join(' ')
  end

  def self.countdown
    Delayed::Job.where(delayed_reference_type: self.to_s).count
  end
end