class BatchImport < ActiveRecord::Base
  mount_uploader :import_file, BatchImportUploader

  after_initialize :default_values

  def default_values
    self.imported_at = DateTime.now
  end

  def open_spreadsheet
    case File.extname(import_file_identifier)
    when ".xlsx" then Roo::Excelx.new(import_file.current_path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def import
    spreadsheet = nil
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    pathology_case = nil
    saved_pathology_cases = []
    note = ''
    (2..spreadsheet.last_row).each do |i|
      if spreadsheet.row(i).compact.size > 3
        save_pathology_case(pathology_case, note)
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
      else
        note += spreadsheet.row(i).compact.join(' ') +  "\r\n"
      end
    end
    save_pathology_case(pathology_case, note)
  end

  def save_pathology_case(pathology_case, note)
    if !pathology_case.nil? && pathology_case.is_a?(PathologyCase)
      note.gsub!('_x000D_', '')
      pathology_case.note = note
      pathology_case.save!
      pathology_case.abstract
    end
    pathology_case
  end
end