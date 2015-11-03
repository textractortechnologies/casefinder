require 'rails_helper'

RSpec.describe SqlAudit, :type => :model do
  before(:each) do
    @pathology_case_1 = FactoryGirl.create(:pathology_case, accession_number: '123')
    @pathology_case_2 = FactoryGirl.create(:pathology_case, accession_number: '124')
  end

  describe 'finding' do
    before(:each) do
      @pathology_cases = SqlAudit.find_and_audit('littlemy', PathologyCase.where('1=1'))
    end

    it 'when given inclusionary criteira', focus: false do
      expect(@pathology_cases).to match_array([@pathology_case_1, @pathology_case_2])
    end

    it "creates a sql audit", focus: false do
      sql_audit = SqlAudit.first
      expect({ username: sql_audit.username, sql: sql_audit.sql, auditable_type: sql_audit.auditable_type, auditable_ids: sql_audit.auditable_ids }).to eq({:username=>"littlemy", :sql=>"SELECT `pathology_cases`.* FROM `pathology_cases` WHERE (1=1)", :auditable_type=>"PathologyCase", :auditable_ids=>"{\"id\":[#{@pathology_case_1.id},#{@pathology_case_2.id}]}"})
    end
  end

  describe 'not finding' do
    before(:each) do
      @pathology_cases = SqlAudit.find_and_audit('littlemy', PathologyCase.where('1=2'))
    end

    it 'when given exclusionary criteria', focus: false do
      expect(@pathology_cases).to be_empty
    end

    it "creates a sql audit without identifiers", focus: false do
      sql_audit = SqlAudit.first
      expect({ username: sql_audit.username, sql: sql_audit.sql, auditable_type: sql_audit.auditable_type, auditable_ids: sql_audit.auditable_ids }).to eq({:username=>"littlemy", :sql=>"SELECT `pathology_cases`.* FROM `pathology_cases` WHERE (1=2)", :auditable_type=>"PathologyCase", :auditable_ids=> nil})
    end
  end
end