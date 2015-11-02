Given /^pathology cases with the following information exist$/ do |table|
  table.hashes.each_with_index do |pathology_case_hash, i|
    pathology_case = FactoryGirl.create(:pathology_case, note: pathology_case_hash['Note'], accession_number: pathology_case_hash['Accession Number'], collection_date: Date.parse(pathology_case_hash['Collection Date']))

    if pathology_case_hash['Patient']
      pathology_case.patient_first_name, pathology_case.patient_last_name = pathology_case_hash['Patient'].split(' ')
    end

    if pathology_case_hash['MRN']
      pathology_case.mrn = pathology_case_hash['MRN']
    end

    if pathology_case_hash['SSN']
      pathology_case.ssn = pathology_case_hash['SSN']
    end

    if pathology_case_hash['Birth Date']
      pathology_case.birth_date = Date.parse(pathology_case_hash['Birth Date'])
    end

    if pathology_case_hash['Sex']
      pathology_case.sex = pathology_case_hash['Sex']
    end

    if pathology_case_hash['Attending']
      pathology_case.attending = pathology_case_hash['Attending']
    end

    if pathology_case_hash['Surgeon']
      pathology_case.surgeon = pathology_case_hash['Surgeon']
    end
    pathology_case.save!
    pathology_case.abstract
  end
end

When(/^I visit the pathology cases index page$/) do
  visit(pathology_cases_path())
end

When(/^click "(.*?)" for accession number "(.*?)"$/) do |link, accession_number|
  pathology_case = PathologyCase.where(accession_number: accession_number).first
  within("#pathology_case_#{pathology_case.id}") do
    click_link("Review")
  end
end

Then(/^I should see pathology cases with the following information( in order)?$/) do |in_order, table|
  expect(all('.pathology_case').size).to eq(table.hashes.size)
  pathology_cases = all('.pathology_case')

  table.hashes.each_with_index do |pathology_case_hash, i|
    pathology_case = PathologyCase.where(accession_number: pathology_case_hash['Accession Number']).first
    if in_order
      expect(pathology_cases[i]['id']).to eq("pathology_case_#{pathology_case.id}")
    end

    expect(page.has_css?("tr#pathology_case_#{pathology_case.id}")).to be_truthy
    expect(page.has_css?("tr#pathology_case_#{pathology_case.id} .pathology_case_accession_number", text: pathology_case_hash['Accession Number'])).to be_truthy
    expect(page.has_css?("tr#pathology_case_#{pathology_case.id} .pathology_case_collection_date", text: pathology_case_hash['Collection Date'])).to be_truthy
    if pathology_case_hash['Suggested Histologies'].blank?
      expect(page.has_css?("tr#pathology_case_#{pathology_case.id} .suggested_histologies", text: '')).to be_truthy
    else
      pathology_case_hash['Suggested Histologies'].split('&').each do |histology|
        expect(page.has_css?("tr#pathology_case_#{pathology_case.id} .suggested_histologies", text: histology)).to be_truthy
      end
    end
    if pathology_case_hash['Suggested Sites'].blank?
      expect(page.has_css?("tr#pathology_case_#{pathology_case.id} .suggested_sites", text: '')).to be_truthy
    else
      pathology_case_hash['Suggested Sites'].split('&').each do |site|
        expect(page.has_css?("tr#pathology_case_#{pathology_case.id} .suggested_sites", text: site)).to be_truthy
      end
    end
  end
end

Then(/^(?:|I )should be on the edit page of accession number "(.*?)"/) do |accession_number|
  pathology_case = PathologyCase.where(accession_number: accession_number).first
  current_path = URI.parse(current_url).path
  expect(current_path).to eq(edit_pathology_case_path(pathology_case))
end