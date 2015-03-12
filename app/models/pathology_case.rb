require 'roo'
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

  scope :search_across_fields, ->(search_token) do
    if search_token
      where("lower(accession_number) like ?", "%#{search_token.downcase}%")
    end
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      pathology_case = PathologyCase.where(accession_number: row['accession_nbr']).first_or_initialize
      pathology_case.encounter_date       = DateTime.parse(row['case_collect_date_time'].strip).to_date
      pathology_case.patient_last_name    = 'Baines'
      pathology_case.patient_first_name   = 'Harold'
      pathology_case.patient_middle_name  = nil
      pathology_case.mrn                  = '12345678'
      pathology_case.ssn                  = '111111111'
      pathology_case.birth_date           = DateTime.parse('7/4/1976').to_date
      pathology_case.address_line_1       = '333 West 35th Street'
      pathology_case.address_line_2       = nil
      pathology_case.city                 = 'Chicago'
      pathology_case.state                = 'IL'
      pathology_case.zip_code             = '60616'
      pathology_case.home_phone           = '3124444444'
      pathology_case.gender               = 'Male'
      pathology_case.note                 = row['diagnosis']
      pathology_case.save!
      pathology_case.delay.abstract
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
end