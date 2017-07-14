When(/^I visit the new batch export page$/) do
  visit(new_batch_export_path())
end

When(/^I fill in "(.*?)" autocompleter with the latest batch export$/) do |locator|
  batch_export = last_batch_export
  value = "#{batch_export.id} (#{batch_export.exported_at.to_date.to_s(:date)})"
  all(locator).should_not be_empty
  all(locator).each{|e| e.set(value)}
  menuitem = '.ui-menu-item a:contains(\"' + value + '\")'
  page.execute_script " $('#{menuitem}').trigger(\"mouseenter\").click();"
end

Then(/^I should see batch exports with the following information( in order)?$/) do |in_order, table|
  expect(all('.abstractor_abstraction_group').size).to eq(table.hashes.size)
  abstractor_abstraction_groups = all('.abstractor_abstraction_group')

  table.hashes.each_with_index do |abstractor_abstraction_group_hash, i|
    cancer_diagnoses = PathologyCase.where(accession_number: abstractor_abstraction_group_hash['Accession Number']).first.with_cancer_diagnoses
    cancer_diagnosis = cancer_diagnoses.detect { |cancer_diagnosis| cancer_diagnosis.has_cancer_histology == abstractor_abstraction_group_hash['Histology'] && cancer_diagnosis.has_cancer_site == abstractor_abstraction_group_hash['Site'] }
    if in_order
      expect(abstractor_abstraction_groups[i]['id']).to eq("abstractor_abstraction_group_#{cancer_diagnosis.abstractor_abstraction_group_id}")
    end

    expect(page.has_css?("tr#abstractor_abstraction_group_#{cancer_diagnosis.abstractor_abstraction_group_id}")).to be_truthy
    expect(page.has_css?("tr#abstractor_abstraction_group_#{cancer_diagnosis.abstractor_abstraction_group_id} .pathology_case_accession_number", text: abstractor_abstraction_group_hash['Accession Number'])).to be_truthy
    expect(page.has_css?("tr#abstractor_abstraction_group_#{cancer_diagnosis.abstractor_abstraction_group_id} .pathology_case_collection_date", text: abstractor_abstraction_group_hash['Collection Date'])).to be_truthy
    expect(page.has_css?("tr#abstractor_abstraction_group_#{cancer_diagnosis.abstractor_abstraction_group_id} .histology", text: abstractor_abstraction_group_hash['Histology'])).to be_truthy
    expect(page.has_css?("tr#abstractor_abstraction_group_#{cancer_diagnosis.abstractor_abstraction_group_id} .site", text: abstractor_abstraction_group_hash['Site'])).to be_truthy
  end
end

Then(/^I should see not fully set batch exports with the following information$/) do |table|
  expect(all('.abstractor_abstraction_group').size).to eq(table.hashes.size)
  abstractor_abstraction_groups = all('.abstractor_abstraction_group')

  table.hashes.each_with_index do |abstractor_abstraction_group_hash, i|
    abstractor_abstraction_group =
    expect(all('.abstractor_abstraction_group .pathology_case_accession_number')[i].text).to eq(abstractor_abstraction_group_hash['Accession Number'])
    expect(all('.abstractor_abstraction_group .pathology_case_collection_date')[i].text).to eq(abstractor_abstraction_group_hash['Collection Date'])
    expect(all('.abstractor_abstraction_group .histology')[i].text).to eq(abstractor_abstraction_group_hash['Histology'])
    expect(all('.abstractor_abstraction_group .site')[i].text).to eq(abstractor_abstraction_group_hash['Site'])
  end
end

Then(/^(?:|I )should be on the edit page of the most recent batch export/) do
  batch_export = last_batch_export
  current_path = URI.parse(current_url).path
  expect(current_path).to eq(batch_export_path(batch_export))
end

Then(/^the pathology case with the accesion number "([^"]*)" becomes not fully set$/) do |accession_number|
  pathology_case = PathologyCase.where(accession_number: accession_number).first

  abstractor_abstraction = pathology_case.abstractor_abstractions.first
  abstractor_abstraction.abstractor_suggestions.each do |abstractor_suggestion|
    abstractor_suggestion.accepted = false
    abstractor_suggestion.save!
  end
end

def last_batch_export
  BatchExport.order('id DESC').limit(1).first
end