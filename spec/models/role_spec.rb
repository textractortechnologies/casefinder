require 'rails_helper'

RSpec.describe Role, :type => :model do
  it 'works', focus: true do
    FactoryGirl.create(:role, name: 'foo', external_identifier: 'foo')
    expect(Role.count).to eq(1)
  end
end