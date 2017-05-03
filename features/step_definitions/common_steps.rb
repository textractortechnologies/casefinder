Given(/^roles are setup$/) do
  CaseFinder::Setup.setup_roles
end

Given(/^"(.*?)" is authorized$/) do |username|
  allow(User).to receive(:determine_roles).and_return(Role.all)
end

Given(/^"([^"]*)" is authorized as an admin$/) do |arg1|
  allow(User).to receive(:determine_roles).and_return(Role.where(name: Role::ROLE_CASEFINDER_ADMIN))
end

Given(/^"([^"]*)" is authorized as a user$/) do |arg1|
  allow(User).to receive(:determine_roles).and_return(Role.where(name: Role::ROLE_CASEFINDER_USER))
end

Given(/^"(.*?)" is not authorized$/) do |username|
  allow(User).to receive(:determine_roles).and_return([])
end

When(/^I visit the pathology cases index page$/) do
  visit(pathology_cases_path())
end

When(/^I visit the new import page$/) do
  visit(new_batch_import_path())
end

When(/^I visit the new export page$/) do
  visit(new_batch_export_path())
end

When(/^I visit the abstactor abstraction schemas page$/) do
  visit(abstractor.abstractor_abstraction_schemas_path())
end

When(/^I visit the index page for the "([^"]*)" abstractor abstraction schema$/) do |predicate|
  abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: predicate).first
  visit(abstractor.abstractor_abstraction_schema_abstractor_object_values_path(abstractor_abstraction_schema))
end

When(/^I visit the new abstractor object value page for the "([^"]*)" abstractor abstraction schema$/) do |predicate|
  abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: predicate).first
  visit(abstractor.new_abstractor_abstraction_schema_abstractor_object_value_path(abstractor_abstraction_schema))
end

When(/^I visit the edit page for the first abstractor object value$/) do
  node_id = all('.abstractor_object_value')[0]['id']
  abstractor_object_value_id  = node_id.match('\d+')[0].to_i
  @abstractor_object_value = Abstractor::AbstractorObjectValue.find(abstractor_object_value_id)
  all('.abstractor_object_value')[0].find('.edit_abstractor_abstraction_schema_abstractor_object_value_link').click
end

When(/^I log out$/) do
  visit(destroy_user_session_url())
end

When /^I wait (\d+) seconds$/ do |wait_seconds|
  sleep(wait_seconds.to_i)
end

When /^I check "([^\"]*)" within(?: the (first|last))? "([^\"]*)"$/ do |label, position, selector|
  position ||= 'first'
  within_scope(get_scope(position, selector)) {
    check(label)
  }
end

When(/^I select "(.*?)" from "(.*?)"$/) do |value, select|
  select(value, from: select)
end

When(/^I click the "(.*?)" button$/) do |button|
  page.evaluate_script('window.confirm = function() { return true; }')
  click_button(button)
end

When(/^"(.*?)" logs in with password "(.*?)"$/) do |username, password|
  visit(new_user_session_path())
  fill_in('Username', with: username)
  fill_in('Password', with: password)
  click_button('Log in')
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |input, value|
  case value
  when 'today'
    value = Date.today
  when 'tomorrow'
    value = (Date.today + 1)
  end

  fill_in(input, with: value)
end

When(/^I click "(.*?)"(?: within "(.*?)")$/) do |link, selector|
  within(selector) do
    page.evaluate_script('window.confirm = function() { return true; }')
    click_link(link)
  end
end

When(/^I choose the "(.*?)" radio button$/) do |radio_button|
  choose(radio_button)
end

Then(/^the "(.*?)" select should have "(.*?)" selected$/) do |select, value|
  expect(page.has_select?(select, selected: value)).to be_truthy
end

Then(/^I should( not)? see "(.*?)" within "(.*?)"$/) do |negate, content, selector|
  if negate
    expect(page.has_css?(selector, text: content)).to be_falsy
  else
    expect(page.has_css?(selector, text: content)).to be_truthy
  end
end

Then(/^the "([^"]*)" radio button should( not)? be checked$/) do |checkbox, negate|
  if negate
    expect(find_field(checkbox)['checked']).to be_falsy
  else
    expect(find_field(checkbox)['checked']).to be_truthy
  end
end

Then(/^the "(.*?)" button should( not)? be disabled$/) do |locator, negate|
  if negate
    expect(find(locator)['disabled']).to be_falsy
  else
    expect(find(locator)['disabled']).to be_truthy
  end
end

Then "the downloaded file content should be:" do |content|
  #Next 2 lines are a hack to get around how Cucumber handles doc string arugments.  It strips trailing spaces.
  content.gsub!("\\n", "\n" )
  content.gsub!('&nbsp;', ' ')
  download_content.should == content
end

Then(/^I should be on the sign in page$/) do
  match_path(new_user_session_path())
end

Then(/^I should be on the home page$/) do
  match_path(root_path())
end

Then(/^I should be on the new import page$/) do
  match_path(new_batch_import_path())
end

Then(/^I should be on the new export page$/) do
  match_path(new_batch_export_path())
end

Then(/^I should be on the pathology cases index page$/) do
  match_path(pathology_cases_path())
end

Then(/^I should be on the abstractor abstraction schemas page$/) do
  match_path(abstractor.abstractor_abstraction_schemas_path())
end

Then(/^I should be on the index page for the "([^"]*)" abstractor abstraction schema$/) do |predicate|
  abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: predicate).first
  match_path(abstractor.abstractor_abstraction_schema_abstractor_object_values_path(abstractor_abstraction_schema))
end

Then(/^I should be on the new abstractor object value page for the "([^"]*)" abstractor abstraction schema$/) do |predicate|
  abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: predicate).first
  match_path(abstractor.new_abstractor_abstraction_schema_abstractor_object_value_path(abstractor_abstraction_schema))
end

Then(/^I should be on the edit abstractor object value page for the "([^"]*)" abstractor abstraction schema$/) do |predicate|
  abstractor_abstraction_schema = Abstractor::AbstractorAbstractionSchema.where(predicate: predicate).first
  match_path(abstractor.edit_abstractor_abstraction_schema_abstractor_object_value_path(abstractor_abstraction_schema, @abstractor_object_value))
end

Then(/^I should be informed that I am unauthorized$/) do
  match_path(main_app.root_path)
  expect(all('#flash')[0].text).to eq(ApplicationController::UNAUTHORIZED_MESSAGE)
end

def match_path(path)
  current_path = URI.parse(current_url).path
  expect(current_path).to eq(path)
end

def within_scope(locator)
  locator ? within(locator) { yield } : yield
end

def get_scope(position, selector)
  return unless selector
  items = page.all("#{selector}")
  case position
  when 'first'
    item = items.first
  when 'last'
    item = items.last
  else
    item = items.last
  end
  item
end

# Example usage:
# Then the "Product" records should match
#   | name           | description          | date_available           |
#   | Ruby Book      | Ruby guide           | DATE: Date.today         |
#   | Rails Book     | A Ruby on Rails text | DATE: Date.today + 1.day |

# -----------------------------------------
# See that the given model has records that
# exactly match the columns given in the table
# -----------------------------------------
Then /^the "([^\"]*)" records should match$/ do |model_name, table|
  # What model are we dealing with
  model_class = model_name.constantize

  # Make sure the number of records matches the number of entries in the
  # test table
  "Record Count:#{model_class.count}".should == "Record Count:#{table.hashes.count}"

  # Sort the records as we search using the field name order
  field_list_csv = table.hashes.first.collect { |field| field[0].to_s }.join(', ')

  # Loop through the table given
  table.hashes.each_with_index do |record, i|
    # Fetch the record corresponding with the row we are on
    record_to_test = model_class.limit(1).offset(i).first

    # Review each input filter
    record.each_pair do |field_name, raw_expected_value|
      # See if the filter value uses out magical dynamic date formatting
      if raw_expected_value.is_a?(String) &&
        (match_data = raw_expected_value.match(/^DATE: (.+?)$/) || match_data = raw_expected_value.match(/^VALUE: (.+?)$/))
        # Get the portion of the regex that has the executable code
        ruby_date_code = match_data[1]

        # run the code and replace the old value
        expected_value = eval(ruby_date_code)
      elsif raw_expected_value.is_a?(String) && (raw_expected_value.scan(/"(DATE: (.+?))"/).any? || raw_expected_value.scan(/"VALUE: (.+?)"/).any?)
        expected_value = raw_expected_value

        expected_value.scan(/"(DATE: (.+?))"/).each do |match_data|
          expected_value.gsub!(match_data[0], eval(match_data[1]).to_s)
        end

        expected_value.scan(/"(VALUE: (.+?))"/).each do |match_data|
          expected_value = expected_value.gsub!(match_data[0], eval(match_data[1]).to_s)
        end
      else
        expected_value = raw_expected_value
      end
      # Get the value in the database for the current field
      value_to_test = record_to_test.read_attribute(field_name)

      # Verify that the correct value exists
      "#{field_name}:#{value_to_test.to_s}".should == "#{field_name}:#{expected_value.to_s}"
    end
  end
end