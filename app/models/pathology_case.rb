require 'roo'
require 'csv'
class PathologyCase < ActiveRecord::Base
  include Abstractor::Abstractable

  scope :by_encounter_date, ->(date_from, date_to) do
    if (!date_from.blank? && !date_to.blank?)
      date_range = [date_from, date_to]
    else
      date_range = []
    end

    unless (date_range.first.blank? || date_range.last.blank?)
      where("encounter_date BETWEEN ? AND ?", date_range.first, date_range.last)
    end
  end

  scope :search_across_fields, ->(search_token, options={}) do
    options = { abstractor_abstraction_schemas: abstractor_abstraction_schemas }.merge(options)

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

  def self.prepare_joins_and_select_clauses(sort_column, sort_direction)
    joins_clause = nil
    predicate = case sort_column
    when 'suggested_histologies'
      'has_cancer_histology'
    when 'suggested_sites'
      'has_cancer_site'
    end

    if predicate
      abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: predicate).first
      joins_clause ="
      LEFT JOIN LATERAL(
      SELECT  aa.about_id
            , sug.suggested_value
      FROM abstractor_abstractions aa JOIN abstractor_suggestions sug ON aa.id = sug.abstractor_abstraction_id AND aa.deleted_at IS NULL
                                      JOIN abstractor_subjects sub ON aa.abstractor_subject_id = sub.id and sub.abstractor_abstraction_schema_id = #{abstractor_abstraction_schema.id}
      WHERE aa.about_id = pathology_cases.id
      ORDER BY sug.suggested_value #{sort_direction} LIMIT 1
       ) AS suggestions ON TRUE"
    end
    joins_clause
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      accession_num = row['ACCESSION_NUM'].is_a?(Float) ? row['ACCESSION_NUM'].to_i.to_s : row['ACCESSION_NUM']
      pathology_case = PathologyCase.where(accession_number: accession_num).first_or_initialize
      pathology_case.encounter_date       = DateTime.parse(row['ENC_DATE'].to_s.strip).to_date
      pathology_case.patient_last_name    = row['LAST_NAME']
      pathology_case.patient_first_name   = row['FIRST_NAME']
      pathology_case.patient_middle_name  = row['MIDDLE_NAME']
      mrn = row['MRN'].is_a?(Float) ? row['MRN'].to_i.to_s : row['MRN']
      pathology_case.mrn                  = mrn
      pathology_case.ssn                  = row['SSN']
      pathology_case.birth_date           = DateTime.parse(row['BIRTH_DATE'].to_s.strip).to_date
      pathology_case.address_line_1       = row['ADDR_LINE_1']
      pathology_case.address_line_2       = row['ADDR_LINE_2']
      pathology_case.city                 = row['CITY']
      pathology_case.state                = row['STATE_CODE']
      zip_code = row['ZIP_CODE'].is_a?(Float) ? row['ZIP_CODE'].to_i.to_s : row['ZIP_CODE']
      pathology_case.zip_code             = zip_code
      pathology_case.home_phone           = row['HOME_PHONE']
      pathology_case.gender               = row['GENDER_CODE']
      pathology_case.note                 = row['PATH_RESULT_TEXT']
      pathology_case.save!
      Delayed::Job.enqueue ProcessPathologyCaseJob.new(pathology_case.id)
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def patient_full_name
    [patient_first_name.titleize, patient_last_name.titleize].reject { |n| n.nil? or n.blank?  }.join(' ')
  end

  def self.to_csv(pathology_cases, options = {})
    headers = ['patient_last_name', 'patient_first_name', 'mrn', 'ssn', 'birth_date', 'has_cancer_site', 'address_line_1', 'city', 'state', 'zip_code', 'home_phone', 'vocabulary_code', 'vocabulary', 'vocabulary_version']
    CSV.generate(options) do |csv|
      csv << headers
      pathology_cases.each do |pathology_case|
        pathology_case.with_cancer_diagnoses.joins('JOIN abstractor_object_values aov ON has_cancer_site = aov.value JOIN abstractor_abstraction_schema_object_values aasov ON aov.id = aasov.abstractor_object_value_id').select('pathology_cases.*, aov.vocabulary_code, aov.vocabulary, aov.vocabulary_version').each do |site|
          csv << site.attributes.values_at(*headers)
        end
      end
    end
  end

  def self.to_metriq(pathology_cases)
    MetriqDocument.new(pathology_cases).generate
  end

  def with_cancer_diagnoses
    PathologyCase.pivot_grouped_abstractions('Cancer Diagnosis').where(id: id)
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

  def addr_no_and_street
    [address_line_1, address_line_2].reject { |n| n.nil? or n.blank? }.join(' ')
  end

  def self.countdown
    Delayed::Job.where(delayed_reference_type: self.to_s).count
  end
end