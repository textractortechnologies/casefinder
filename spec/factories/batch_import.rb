FactoryGirl.define do
  factory :excel_batch_import, class: BatchImport do
    import_file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/batch_imports/north_shore_12_pathology_cases.xlsx')))
  end
end

FactoryGirl.define do
  factory :hl7_batch_import, class: BatchImport  do
    import_file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/batch_imports/north_shore_1.txt')))
  end
end