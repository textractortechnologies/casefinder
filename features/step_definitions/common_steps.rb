Given(/^roles are setup$/) do
  CaseFinder::Setup.setup_roles
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