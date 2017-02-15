FactoryGirl.define do
  factory :hl7_batch_import_order_orm, class: BatchImportOrder  do
    import_body File.read(File.join(Rails.root, '/spec/fixtures/batch_import_orders/orm.txt'))
  end
end

FactoryGirl.define do
  factory :hl7_batch_import_order_orm_update, class: BatchImportOrder  do
    import_body File.read(File.join(Rails.root, '/spec/fixtures/batch_import_orders/orm_update.txt'))
  end
end

FactoryGirl.define do
  factory :hl7_batch_import_order_orm_no_mrn, class: BatchImportOrder  do
    import_body File.read(File.join(Rails.root, '/spec/fixtures/batch_import_orders/orm_no_mrn.txt'))
  end
end

FactoryGirl.define do
  factory :hl7_batch_import_order_orr, class: BatchImportOrder  do
    import_body File.read(File.join(Rails.root, '/spec/fixtures/batch_import_orders/orr.txt'))
  end
end

FactoryGirl.define do
  factory :hl7_batch_import_order_orr_update, class: BatchImportOrder  do
    import_body File.read(File.join(Rails.root, '/spec/fixtures/batch_import_orders/orr_update.txt'))
  end
end
