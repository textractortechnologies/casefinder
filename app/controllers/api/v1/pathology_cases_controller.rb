class Api::V1::PathologyCasesController < ApiController
  def create
    if request.headers['Content-Type'] != 'x-application/hl7-v2+er7; charset=utf-8'
      render plain: 'Unsupported Media Type',  content_type: 'text/plain', status: :unsupported_media_type
    elsif request.headers['Date'].blank? || !request.headers['Date'].date?
      render plain: "Missing or malformed 'Date' header",  content_type: 'text/plain', status: :bad_request
    else
      begin
        import_body = request.raw_post
        @batch_import = BatchImport.new(imported_at: DateTime.now, import_body: import_body.encode!('UTF-8'))
        @batch_import.save
        errors = @batch_import.validate_hl7

        if errors.any?
          render plain: @batch_import.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_REJECTION, errors).to_hl7,  content_type: 'x-application/hl7-v2+er7; charset=utf-8', status: :ok
        else
          @batch_import.import
          render plain: @batch_import.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ACCEPT).to_hl7,  content_type: 'x-application/hl7-v2+er7; charset=utf-8', status: :ok
        end
      rescue Exception => e
        Rails.logger.info(e.message)
        Rails.logger.info(e.class)
        Rails.logger.info(e.backtrace)
        render plain: @batch_import.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ERROR).to_hl7,  content_type: 'x-application/hl7-v2+er7; charset=utf-8', status: :ok
      end
    end
  end
end