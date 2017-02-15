require 'spec_helper'
describe Api::V1::OrdersController, type: :request do
  before(:each) do
    CaseFinder::Setup.setup_roles
  end

  describe "POST /api/v1/orders" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      role = Role.where(name: Role::ROLE_CASEFINDER_API).first
      @user.roles << role
      @env = {}
      @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(@user.username, @user.authentication_token)
      @body = File.read(File.join(Rails.root, '/spec/fixtures/batch_import_orders/orm.txt'))
    end

    it 'returns an unauthorized HTTP status code if the request cannot be authenticated', focus: false do
      post '/api/v1/orders', {}, {}
      expect(response.status).to eq(401)
    end

    it 'does not return an unauthorized HTTP status code if the request can be authenticated', focus: false do
      post '/api/v1/orders', @body, @env
      expect(response.status).to_not eq(401)
    end

    it 'does return an unauthorized HTTP status code if the request can be authenticated but not authorized', focus: false do
      @user.role_assignments.destroy_all
      post '/api/v1/orders', @body, @env
      expect(response.status).to eq(401)
    end

    it 'returns unsupported media type HTTP status code if the request has an unsupported media type', focus: false do
      post '/api/v1/orders', @body, @env
      expect(response.status).to eq(415)
      expect(response.body).to eq('Unsupported Media Type')
    end

    it 'does not return an unsupported media type HTTP status code if the request has a supported media type', focus: false do
      @env['Content-Type'] = 'x-application/hl7-v2+er7; charset=utf-8'
      post '/api/v1/orders', @body, @env
      expect(response.status).to_not eq(415)
    end

    it 'returns a bad request HTTP status code if the request does not have a date', focus: false do
      @env['Content-Type'] = 'x-application/hl7-v2+er7; charset=utf-8'
      post '/api/v1/orders', @body, @env
      expect(response.status).to eq(400)
      expect(response.body).to eq("Missing or malformed 'Date' header")
    end

    it 'returns OK HTTP status code and HL7 application rejection ACK if the request fails validaiton', focus: false do
      batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
      @env['Content-Type'] = 'x-application/hl7-v2+er7; charset=utf-8'
      @env['Date'] = DateTime.now.to_s
      allow_any_instance_of(BatchImportOrder).to receive(:validate_hl7).and_return(['Moomin'])
      post '/api/v1/orders', @body, @env
      expect(response.status).to eq(200)
      expect(response.body).to eq(batch_import_order.hl7_ack(BatchImportOrder::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_REJECTION, errors: ['Moomin'], raw: true))
    end

    it 'returns OK HTTP status code and HL7 application error ACK if the request blows up', focus: false  do
      batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
      @env['Content-Type'] = 'x-application/hl7-v2+er7; charset=utf-8'
      @env['Date'] = DateTime.now.to_s
      allow_any_instance_of(BatchImportOrder).to receive(:validate_hl7).and_raise("boom")
      post '/api/v1/orders', @body, @env
      expect(response.status).to eq(200)
      expect(response.body).to eq(batch_import_order.hl7_ack(BatchImport::BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ERROR, raw: true))
    end

    it 'returns OK HTTP status code and HL7 application accept ACK if the request has all headers and a valid body', focus: false do
      batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
      @env['Content-Type'] = 'x-application/hl7-v2+er7; charset=utf-8'
      @env['Date'] = DateTime.now.to_s
      post '/api/v1/orders', @body, @env
      expect(response.status).to eq(200)
      expect(response.body).to eq(batch_import_order.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ACCEPT, raw: true))
    end
  end
end