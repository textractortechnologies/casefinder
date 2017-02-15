require 'rails_helper'

RSpec.describe BatchImportOrder, :type => :model do
  it 'creates an instance of an hl7 file', focus: false do
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    expect(batch_import_order.hl7.instance_of?(HL7::Message)).to be_truthy
  end

  it 'validates an hl7 body', focus: false do
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    expect(batch_import_order.validate_hl7).to be_empty
  end

  it 'validates the message type of an hl7 body', focus: false do
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    batch_import_order.hl7[:MSH].message_type = 'moomin'
    expect(batch_import_order.validate_hl7).to eq([BatchImport::HL7_MESSAGE_TYPE_ERROR])
  end

  it 'validates the version id of an hl7 body', focus: false do
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    batch_import_order.hl7[:MSH].version_id = 'moomin'
    expect(batch_import_order.validate_hl7).to eq([BatchImport::HL7_VERSION_ID_ERROR])
  end

  it 'validates the processing id of an hl7 body', focus: false do
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    batch_import_order.hl7[:MSH].processing_id = 'moomin'
    expect(batch_import_order.validate_hl7).to eq([BatchImport::HL7_PROCESSING_ID_ERROR])
  end

  it 'can create an HL7 ack', focus: false do
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    ack = batch_import_order.hl7_ack(BatchImportOrder::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ACCEPT)
    expect(ack[:MSA]).to_not be_blank
    expect(ack[:MSA].ack_code).to eq(BatchImportOrder::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ACCEPT)
    expect(ack[:MSA].control_id).to eq(batch_import_order.hl7[:MSH].message_control_id)
    expect(ack[:MSH].message_type.scan('ACK')).to_not be_blank
    ack = batch_import_order.hl7_ack(BatchImportOrder::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_REJECTION, errors: ['moomin', 'little my'])
    expect(ack[:MSA].ack_code).to eq(BatchImportOrder::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_REJECTION)
    expect(ack[:MSA].text).to eq('moomin little my')
  end

  it 'can create an HL7 ack in a raw format', focus: false do
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    ack = batch_import_order.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_ACCEPT, raw: true)
    expect(ack).to eq("MSH|^~\\&|EPIC|A||TAM|20170201153215|122535|ACK|2924|T|2.2|||||||||||\rMSA|AA|2924|\r")
    ack = batch_import_order.hl7_ack(BatchImport::HL7_ACKNOWLEDGMENT_CODE_APPLICATION_REJECTION, errors: ['moomin', 'little my'], raw: true)
    expect(ack).to eq("MSH|^~\\&|EPIC|A||TAM|20170201153215|122535|ACK|2924|T|2.2|||||||||||\rMSA|AR|2924|moomin little my\r")
  end

  it 'imports an order from an HL7 body for message type ORM^O01', focus: false do
    expect(Patient.count).to eq(0)
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    batch_import_order.import
    expect(Patient.count).to eq(1)
    patient = Patient.where(cpi: '99999990').first
    expect(patient).to_not be_nil
    expect(patient.cpi).to eq('99999990')
    expect(patient.mrn).to eq('8888880')
    expect(batch_import_order.reload.patient_id).to eq(patient.id)
  end

  it 'imports an order from an HL7 body for message type ORM^O01 but only updates the mrn of an existing cpi', focus: false do
    expect(Patient.count).to eq(0)
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm)
    batch_import_order.import
    expect(Patient.count).to eq(1)
    patient = Patient.where(cpi: '99999990').first
    expect(patient).to_not be_nil
    expect(patient.cpi).to eq('99999990')
    expect(patient.mrn).to eq('8888880')
    expect(batch_import_order.reload.patient_id).to eq(patient.id)
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm_update)
    batch_import_order.import
    expect(Patient.count).to eq(1)
    patient = Patient.where(cpi: '99999990').first
    expect(patient).to_not be_nil
    expect(patient.cpi).to eq('99999990')
    expect(patient.mrn).to eq('66666660')
  end

  it 'imports an order from an HL7 body for message type ORR^O02', focus: false do
    expect(Patient.count).to eq(0)
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orr)
    batch_import_order.import
    expect(Patient.count).to eq(1)
    patient = Patient.where(cpi: '99999990').first
    expect(patient).to_not be_nil
    expect(patient.cpi).to eq('99999990')
    expect(patient.mrn).to eq('77777770')
    expect(batch_import_order.reload.patient_id).to eq(patient.id)
  end

  it 'imports an order from an HL7 body for message type ORM^O01 with no mrn', focus: false do
    expect(Patient.count).to eq(0)
    batch_import_order = FactoryGirl.create(:hl7_batch_import_order_orm_no_mrn)
    batch_import_order.import
    expect(Patient.count).to eq(1)
    patient = Patient.where(cpi: '99999990').first
    expect(patient.cpi).to eq('99999990')
    expect(patient.mrn).to be_nil
    expect(batch_import_order.reload.patient_id).to eq(patient.id)
  end
end