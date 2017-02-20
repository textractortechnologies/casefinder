class BatchImportOrder < ActiveRecord::Base
  has_paper_trail
  HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ACCEPT = 'AA'
  HL7_ACKNOWLEDGMENT_CODE_APPLICATION_REJECTION = 'AR'
  HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ERROR = 'AE'
  HL7_MESSAGE_TYPE_ORR = 'ORR^O02'
  HL7_MESSAGE_TYPE_ORM = 'ORM^O01'
  HL7_MESSAGE_TYPES = [HL7_MESSAGE_TYPE_ORR, HL7_MESSAGE_TYPE_ORM]
  HL7_MESSAGE_TYPE_ERROR = 'Unsupported message type'
  HL7_VERSION_ID = '2.2'
  HL7_VERSION_ID_ERROR = 'Unsupported version id'
  HL7_PROCESSING_ID_TEST = 'T'
  HL7_PROCESSING_ID_PRODUCTION = 'P'
  HL7_PROCESSING_ID_ERROR = 'Unsupported processing id'

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
    if !HL7_MESSAGE_TYPES.include?(hl7[:MSH].message_type)
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
    process_body
  end

  private
    def default_values
      self.imported_at = DateTime.now if self.new_record?
    end

    def process_body
      import_hl7(hl7)
    end

    def import_hl7(message)
      patient_file = nil
      patient = nil

      message.each do |segment|
        if segment.is_a?(HL7::Message::Segment::PID)
          mrn = nil
          cpi = nil
          identifiers = segment.e3.split(segment.item_delim)
          if identifiers.any?
            mrn = identifiers.shift
            identifiers.each do |identifier|
              if identifier.include?('MR')
                identifier = identifier.split('~')
                if identifier.any?
                  cpi = identifier.last
                end
              end
            end
          end

          if mrn
            patient = Patient.where(mrn: mrn).first_or_initialize
          end
          if cpi
            patient.cpi = cpi
          end
          save_patient(patient)
        end
      end
    end

    def save_patient(patient)
      if !patient.nil? && patient.is_a?(Patient)
        patient.save!
        self.patient_id = patient.id
        save!
      end
      patient
    end

    def build_hl7_ack(ack_code, errors=[])
      ack = HL7::Message.new()
      ack << hl7[:MSH]

      sending_app = ack[:MSH].sending_app
      ack[:MSH].sending_app = ack[:MSH].recv_app
      ack[:MSH].sending_app = sending_app

      message_type = ack[:MSH].message_type
      message_type.sub!(message_type,'ACK')

      msa = HL7::Message::Segment::MSA.new
      msa.ack_code = ack_code
      msa.control_id = ack[:MSH].message_control_id
      msa.text = errors.join(' ')

      ack << msa
      ack
    end
end