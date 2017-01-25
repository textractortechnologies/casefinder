class BatchImport < ActiveRecord::Base
  has_paper_trail
  HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ACCEPT = 'AA'
  HL7_ACKNOWLEDGMENT_CODE_APPLICATION_REJECTION = 'AR'
  HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ERROR = 'AE'
  HL7_MESSAGE_TYPE = 'ORU^R01'
  HL7_MESSAGE_TYPE_ERROR = 'Unsupported message type'
  HL7_VERSION_ID = '2.2'
  HL7_VERSION_ID_ERROR = 'Unsupported version id'
  HL7_PROCESSING_ID_TEST = 'T'
  HL7_PROCESSING_ID_PRODUCTION = 'P'
  HL7_PROCESSING_ID_ERROR = 'Unsupported processing id'

  mount_uploader :import_file, BatchImportUploader, on: :file_name

  after_initialize :default_values

  def clean_hl7(hl7_message)
    clean_hl7_message = hl7_message.gsub("\r\n", "\r")
    clean_hl7_message = clean_hl7_message.gsub("\n", "\r")
    if clean_hl7_message.last == "\r"
      clean_hl7_message = clean_hl7_message.chop
    end
    clean_hl7_message
  end

  def hl7
    message = clean_hl7(import_body)
    @hl7 ||= HL7::Message.new(message)
  end

  def validate_hl7
    errors = []
    if hl7[:MSH].message_type != HL7_MESSAGE_TYPE
      errors  << HL7_MESSAGE_TYPE_ERROR
    end

    if hl7[:MSH].version_id != HL7_VERSION_ID
      errors << HL7_VERSION_ID_ERROR
    end

    if ((['development', 'test', 'staging'].include?(Rails.env) && hl7[:MSH].processing_id != HL7_PROCESSING_ID_TEST) || (Rails.env == 'production' && hl7[:MSH].processing_id != HL7_PROCESSING_ID_PRODUCTION))
      errors << HL7_PROCESSING_ID_ERROR
    end

    errors
  end

  def hl7_ack(ack_code, options = {})
    ack = nil
    begin
      options.reverse_merge!({ errors: [], raw: false })
      ack = build_hl7_ack(ack_code, options[:errors])
      if options[:raw]
        ack = ack.to_hl7 + "\r"
      end
    rescue Exception => e
      ack = nil
    end
    ack
  end

  def import
    if import_body
      process_body
    elsif import_file
      process_file
    end
  end

  private
    def default_values
      self.imported_at = DateTime.now
    end

    def process_file
      case File.extname(import_file_identifier)
      when ".xlsx"
        excel_file = Roo::Excelx.new(import_file.current_path, nil, :ignore)
        import_excel(excel_file)
      when ".txt"
        file = File.read(import_file.current_path)
        message = HL7::Message.new(clean_hl7(file))
        import_hl7(message)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end

    def process_body
      import_hl7(hl7)
    end

    def set_pathology_case_from_file(pathology_case_file, pathology_case)
      if pathology_case_file && pathology_case
        pathology_case.attributes = pathology_case_file.attributes.except('id', 'created_at', 'updated_at')
      end
    end

    def import_excel(excel_file)
      header = excel_file.row(1)
      pathology_case = nil
      note = ''
      (2..excel_file.last_row).each do |i|
        if excel_file.row(i).compact.size > 3
          save_pathology_case(pathology_case, note)
          note = ''
          accession_num = excel_file.row(i)[5].is_a?(Float) ? excel_file.row(i)[5].to_i.to_s : excel_file.row(i)[5]
          pathology_case = PathologyCase.new(accession_number: accession_num)
          pathology_case.collection_date       = DateTime.parse(excel_file.row(i)[13].to_s.strip).to_date
          patient_last_name, patient_first_name = excel_file.row(i)[1].split(',')
          pathology_case.patient_last_name          = patient_last_name.strip
          pathology_case.patient_first_name          = patient_first_name.strip
          mrn = excel_file.row(i)[3].is_a?(Float) ? excel_file.row(i)[3].to_i.to_s : excel_file.row(i)[3]
          pathology_case.mrn                  = mrn
          pathology_case.ssn                  = excel_file.row(i)[15]
          pathology_case.birth_date           = DateTime.parse(excel_file.row(i)[7].to_s.strip).to_date unless excel_file.row(i)[7].blank?
          pathology_case.street1              = excel_file.row(i)[17]
          pathology_case.street2              = excel_file.row(i)[19]
          pathology_case.city                 = excel_file.row(i)[21]
          pathology_case.state                = excel_file.row(i)[23]
          zip_code = excel_file.row(i)[25].is_a?(Float) ? excel_file.row(i)[25].to_i.to_s : excel_file.row(i)[25]
          pathology_case.zip_code             = zip_code
          pathology_case.country              = excel_file.row(i)[27]
          pathology_case.home_phone           = excel_file.row(i)[29]
          pathology_case.sex                  = excel_file.row(i)[9]
          pathology_case.race                 = excel_file.row(i)[11]
          pathology_case.attending            = excel_file.row(i)[31]
          pathology_case.surgeon              = excel_file.row(i)[33].blank? ? excel_file.row(i)[33] :  excel_file.row(i)[33]
        else
          note += excel_file.row(i).compact.join(' ') +  "\r\n"
        end
      end
      save_pathology_case(pathology_case, note)
    end

    def import_hl7(message)
      pathology_case_file = nil
      pathology_case = nil
      note = ''
      message.each do |segment|
        if segment.is_a?(HL7::Message::Segment::MSH)
          set_pathology_case_from_file(pathology_case_file, pathology_case)
          save_pathology_case(pathology_case, note)
          pathology_case_file = PathologyCase.new
          pathology_case = nil
          note = ''
        end
        if segment.is_a?(HL7::Message::Segment::PID)
          patient_last_name, patient_first_name = segment.patient_name.split(segment.item_delim)
          pathology_case_file.patient_last_name = patient_last_name
          pathology_case_file.patient_first_name = patient_first_name
          pathology_case_file.birth_date = DateTime.parse(segment.e7.to_s.strip).to_date unless segment.e7.blank?
          pathology_case_file.sex = segment.e8
          pathology_case_file.race = segment.e10
          patient_address = segment.e11.split(segment.item_delim)
          pathology_case_file.street1 = patient_address[0]
          pathology_case_file.street2 = patient_address[1]
          pathology_case_file.city = patient_address[2]
          pathology_case_file.state = patient_address[3]
          pathology_case_file.zip_code = patient_address[4]
          pathology_case_file.country = patient_address[5]
          pathology_case_file.home_phone = segment.e13
          mrn = segment.e3.split(segment.item_delim)
          if mrn.any?
            mrn = mrn.first
            pathology_case_file.mrn = mrn
          end
          pathology_case_file.ssn =  segment.e19
        end

        if segment.is_a?(HL7::Message::Segment::PV1)
          if !segment.e7.blank?
            attending = segment.e7.split(segment.item_delim)
            if attending.size == 7
              pathology_case_file.attending = [attending[1], attending[6]].delete_if(&:empty?).join(' ') + ', ' + attending[2]
            else
              pathology_case_file.attending = attending[1] + ', ' + attending[2]
            end

          end

          if !segment.e8.blank?
            surgeon = segment.e8.split(segment.item_delim)
            if surgeon.size == 7
              pathology_case_file.surgeon = [surgeon[1], surgeon[6]].delete_if(&:empty?).join(' ')  + ', ' + surgeon[2]
            else
              pathology_case_file.surgeon = surgeon[1] + ', ' + surgeon[2]
            end
          end
        end

        if segment.is_a?(HL7::Message::Segment::OBR)
          pathology_case_file.accession_number = segment.e3
          pathology_case_file.collection_date = DateTime.parse(segment.e7.to_s.strip).to_date
          pathology_case = PathologyCase.new(accession_number: pathology_case_file.accession_number)
        end

        if segment.is_a?(HL7::Message::Segment::OBX)
          note += segment.e5 + " \r\n"
        end
      end

      set_pathology_case_from_file(pathology_case_file, pathology_case)
      save_pathology_case(pathology_case, note)
    end

    def save_pathology_case(pathology_case, note)
      if !pathology_case.nil? && pathology_case.is_a?(PathologyCase)
        note.gsub!('_x000D_', '')
        pathology_case.note = note
        pathology_case.save!
        pathology_case.abstract
        self.pathology_case_id = pathology_case.id
        save!
      end
      pathology_case
    end

    def build_hl7_ack(ack_code, errors=[])
      ack = HL7::Message.new()
      ack << hl7[:MSH]

      sending_app = ack[:MSH].sending_app
      ack[:MSH].sending_app = ack[:MSH].recv_app
      ack[:MSH].sending_app = sending_app

      message_type = ack[:MSH].message_type
      message_type.sub!('ORU','ACK')

      msa = HL7::Message::Segment::MSA.new
      msa.ack_code = ack_code
      msa.control_id = ack[:MSH].message_control_id
      msa.text = errors.join(' ')

      ack << msa
      ack
    end
end