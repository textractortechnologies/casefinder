class Api::V1::PathologyCasesController < ApiController
  before_action :audit_activity
  def create
    # Rails.logger.info("Here is the raw post")
    # Rails.logger.info("#{request.raw_post}")
    if request.headers['Content-Type'] != 'x-application/hl7-v2+er7; charset=utf-8'
      render plain: 'Unsupported Media Type',  content_type: 'text/plain', status: :unsupported_media_type
    elsif request.headers['Date'].blank? || !request.headers['Date'].date?
      render plain: "Missing or malformed 'Date' header",  content_type: 'text/plain', status: :bad_request
    else
      begin
        import_body = request.raw_post
        @batch_import = BatchImport.new(imported_at: DateTime.now, import_body: import_body.encode!('UTF-8', invalid: :replace, undef: :replace))
        @batch_import.save
        errors = @batch_import.validate_hl7

        if errors.any?
          ack = @batch_import.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_REJECTION, errors: errors, raw: true)
          @batch_import.status = ack
          @batch_import.save!
          render plain: ack, content_type: 'x-application/hl7-v2+er7; charset=utf-8', status: :ok
        else
          @batch_import.import(abstract_multiple: true)
          ack = @batch_import.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ACCEPT, raw: true)
          @batch_import.status = ack
          @batch_import.save!
          render plain: ack, content_type: 'x-application/hl7-v2+er7; charset=utf-8', status: :ok
        end
      rescue Exception => e
        ExceptionNotifier.notify_exception(e, :env => request.env)
        Rails.logger.info("Api::V1::PathologyCasesController unhandled error.  Please fix.")
        Rails.logger.info(e.message)
        Rails.logger.info(e.class)
        Rails.logger.info(e.backtrace)
        ack = @batch_import.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ERROR, raw: true)
        if ack.present?
          @batch_import.status = ack
          @batch_import.save
          render plain: ack,  content_type: 'x-application/hl7-v2+er7; charset=utf-8', status: :ok
        else
          render plain: "Unrecoverable error.",  content_type: 'text/plain', status: :bad_request
        end
      end
    end
  end
end