require 'roo'
require 'csv'
require "benchmark"
class PathologyCase < ActiveRecord::Base
  include Abstractor::Abstractable

  scope :by_collection_date, ->(date_from, date_to) do
    if (!date_from.blank? && !date_to.blank?)
      date_range = [date_from, date_to]
    else
      date_range = []
    end

    unless (date_range.first.blank? || date_range.last.blank?)
      where("collection_date BETWEEN ? AND ?", date_range.first, date_range.last)
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

    if sort_direction == 'ASC'
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

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    pathology_case = nil
    saved_pathology_cases = []
    note = ''
    (2..spreadsheet.last_row).each do |i|
      if spreadsheet.row(i).compact.size > 3
        time = Benchmark.realtime do
          save_pathology_case(pathology_case, note)
          if pathology_case
            saved_pathology_cases << pathology_case
          end
          note = ''
          accession_num = spreadsheet.row(i)[5].is_a?(Float) ? spreadsheet.row(i)[5].to_i.to_s : spreadsheet.row(i)[5]
          pathology_case = PathologyCase.where(accession_number: accession_num).first_or_initialize
          pathology_case.collection_date       = DateTime.parse(spreadsheet.row(i)[13].to_s.strip).to_date
          patient_last_name, patient_first_name = spreadsheet.row(i)[1].split(',')
          pathology_case.patient_last_name          = patient_last_name.strip
          pathology_case.patient_first_name          = patient_first_name.strip
          mrn = spreadsheet.row(i)[3].is_a?(Float) ? spreadsheet.row(i)[3].to_i.to_s : spreadsheet.row(i)[3]
          pathology_case.mrn                  = mrn
          pathology_case.ssn                  = spreadsheet.row(i)[15]
          pathology_case.birth_date           = DateTime.parse(spreadsheet.row(i)[7].to_s.strip).to_date unless spreadsheet.row(i)[7].blank?
          pathology_case.street1              = spreadsheet.row(i)[17]
          pathology_case.street2              = spreadsheet.row(i)[19]
          pathology_case.city                 = spreadsheet.row(i)[21]
          pathology_case.state                = spreadsheet.row(i)[23]
          zip_code = spreadsheet.row(i)[25].is_a?(Float) ? spreadsheet.row(i)[25].to_i.to_s : spreadsheet.row(i)[25]
          pathology_case.zip_code             = zip_code
          pathology_case.country              = spreadsheet.row(i)[27]
          pathology_case.home_phone           = spreadsheet.row(i)[29]
          pathology_case.sex                  = spreadsheet.row(i)[9]
          pathology_case.race                 = spreadsheet.row(i)[11]
          pathology_case.attending            = spreadsheet.row(i)[31]
          pathology_case.surgeon              = spreadsheet.row(i)[33].blank? ? spreadsheet.row(i)[31] :  spreadsheet.row(i)[31]
        end
        Rails.logger.info("Patient row: Little my says how long time elapsed #{time*1000} milliseconds)")
      else
        time = Benchmark.realtime do
          note += spreadsheet.row(i).compact.join(' ') +  "\r\n"
        end
        Rails.logger.info("Note row: Little my says how long time elapsed #{time*1000} milliseconds)")
      end
    end
    save_pathology_case(pathology_case, note)
    if pathology_case
      saved_pathology_cases << pathology_case
    end
    saved_pathology_cases.each do |saved_pathology_case|
      Delayed::Job.enqueue ProcessPathologyCaseJob.new(saved_pathology_case.id)
    end
  end

  def self.save_pathology_case(pathology_case, note)
    if !pathology_case.nil? && pathology_case.is_a?(PathologyCase)
      note.gsub!('_x000D_', '')
      pathology_case.note = note
      pathology_case.save!
    end
    pathology_case
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
    [street1, street2].reject { |n| n.nil? or n.blank? }.join(' ')
  end

  def self.countdown
    Delayed::Job.where(delayed_reference_type: self.to_s).count
  end
end