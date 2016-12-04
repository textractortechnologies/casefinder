require 'rails_helper'

RSpec.describe PathologyCase, :type => :model do
  before(:all) do
    Abstractor::Setup.system
    source_type_nlp_suggestion = Abstractor::AbstractorAbstractionSourceType.where(name: 'nlp suggestion').first
    lightweight = true
    CaseFinder::Setup.setup_abstractor_schemas(source_type_nlp_suggestion, lightweight)
  end

  it 'concatenates an address', focus: false do
    pathology_case = FactoryGirl.create(:pathology_case, street1: '123 Moomin St.', street2: 'Apt 1')
    expect(pathology_case.addr_no_and_street).to eq('123 Moomin St. Apt 1')
  end

  it "concatenates a patient's name", focus: false do
    pathology_case = FactoryGirl.create(:pathology_case, patient_last_name: 'moomin', patient_first_name: 'little my', patient_middle_name: nil)
    expect(pathology_case.patient_full_name).to eq('Little My Moomin')
  end

  it "concatenates a patient's name with a middle name", focus: false do
    pathology_case = FactoryGirl.create(:pathology_case, patient_last_name: 'moomin', patient_first_name: 'little my', patient_middle_name: 'trouble')
    expect(pathology_case.patient_full_name).to eq('Little My Trouble Moomin')
  end

  it 'can report suggested histologies', focus: false do
    pathology_case = FactoryGirl.create(:pathology_case, note: "Looks like carcinoma to me.  But maybe large cell carcinoma." )
    pathology_case.abstract
    expect(pathology_case.reload.suggested_histologies).to eq(["carcinoma, nos (8010/3)", "large cell carcinoma, nos (8012/3)"])
  end

  it 'reports no suggested histologies if none exist', focus: false do
    pathology_case = FactoryGirl.create(:pathology_case, note: "Everything looks great!" )
    pathology_case.abstract
    expect(pathology_case.reload.suggested_histologies).to be_empty
  end

  it 'can report suggested sites', focus: false do
    pathology_case = FactoryGirl.create(:pathology_case, note: "Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue." )
    pathology_case.abstract
    expect(pathology_case.reload.suggested_sites).to eq(["base of tongue, nos (c01.9)", "external lip, nos (c00.2)", "lip, nos (c00.9)", "tongue, nos (c02.9)"])
  end

  it 'reports no suggested sites if none exist', focus: false do
    pathology_case = FactoryGirl.create(:pathology_case, note: "Everything looks great!" )
    pathology_case.abstract
    expect(pathology_case.reload.suggested_sites).to be_empty
  end

  it 'can search pathology cases by collection date', focus: false do
    pathology_case_1 = FactoryGirl.create(:pathology_case, collection_date: '2/1/2015')
    pathology_case_2 = FactoryGirl.create(:pathology_case, collection_date: '3/1/2015')
    pathology_case_3 = FactoryGirl.create(:pathology_case, collection_date: '4/1/2015')
    expect(PathologyCase.by_date(PathologyCase::COLLECTION_DATE_DATE_TYPE, '2/15/2015', '5/1/2015')).to match_array([pathology_case_2, pathology_case_3])
  end

  it 'can search pathology cases by imported date', focus: false do
    pathology_case_1 = FactoryGirl.create(:pathology_case, collection_date: '2/1/2013', created_at: '2/1/2015')
    pathology_case_2 = FactoryGirl.create(:pathology_case, collection_date: '3/1/2013', created_at: '3/1/2015')
    pathology_case_3 = FactoryGirl.create(:pathology_case, collection_date: '4/1/2013', created_at: '4/1/2015')

    expect(PathologyCase.by_date(PathologyCase::IMPORTED_DATE_DATE_TYPE, '2/15/2015', '5/1/2015')).to match_array([pathology_case_2, pathology_case_3])
  end

  it 'can search accross fields (by accession number)', focus: false do
    pathology_case_1 = FactoryGirl.create(:pathology_case, accession_number: '123Moomin')
    pathology_case_1.abstract
    pathology_case_2 = FactoryGirl.create(:pathology_case, accession_number: '123TheGroke')
    pathology_case_2.abstract
    expect(PathologyCase.search_across_fields('moomin')).to match_array([pathology_case_1])
  end

  it 'can search accross fields (by accession number) case insensitively', focus: false do
    pathology_case_1 = FactoryGirl.create(:pathology_case, accession_number: '123Moomin')
    pathology_case_1.abstract
    pathology_case_2 = FactoryGirl.create(:pathology_case, accession_number: '123TheGroke')
    pathology_case_2.abstract
    expect(PathologyCase.search_across_fields('MOOMIN')).to match_array([pathology_case_1])
  end

  it 'can search accross fields (by suggested histology)', focus: false do
    pathology_case_1 = FactoryGirl.create(:pathology_case, note: "Looks like carcinoma to me.  But maybe large cell carcinoma." )
    pathology_case_1.abstract

    pathology_case_2 = FactoryGirl.create(:pathology_case, note: "Everything looks great!" )
    pathology_case_2.abstract
    expect(PathologyCase.search_across_fields('carcinoma, nos (8010/3)')).to match_array([pathology_case_1])
  end

  it 'can search accross fields (by suggested site)', focus: false do
    pathology_case_1 = FactoryGirl.create(:pathology_case, note: "Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue." )
    pathology_case_1.abstract

    pathology_case_2 = FactoryGirl.create(:pathology_case, note: "Everything looks great!" )
    pathology_case_2.abstract
    expect(PathologyCase.search_across_fields('tongue, nos (c02.9)')).to match_array([pathology_case_1])
  end

  it 'can search accross fields (and sort ascending/descending by a passed in column)', focus: false do
    pathology_case_1 = FactoryGirl.create(:pathology_case, note: "Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.", patient_last_name: 'Baines', patient_first_name: 'Harold')
    pathology_case_1.abstract

    pathology_case_2 = FactoryGirl.create(:pathology_case, note: "Everything looks great!", patient_last_name: 'Aparicio', patient_first_name: 'Louis')
    pathology_case_2.abstract
    expect(PathologyCase.search_across_fields(nil, { sort_column: 'patient_last_name', sort_direction: 'asc' })).to eq([pathology_case_2, pathology_case_1])
    expect(PathologyCase.search_across_fields(nil, { sort_column: 'patient_last_name', sort_direction: 'desc' })).to eq([pathology_case_1, pathology_case_2])
    expect(PathologyCase.search_across_fields(nil, { sort_column: 'patient_first_name', sort_direction: 'asc' })).to eq([pathology_case_1, pathology_case_2])
    expect(PathologyCase.search_across_fields(nil, { sort_column: 'patient_first_name', sort_direction: 'desc' })).to eq([pathology_case_2, pathology_case_1])
  end

  it 'can output a list of pathology cases in CSV' do
    pending
  end
end