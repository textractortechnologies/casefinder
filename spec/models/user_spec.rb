require 'rails_helper'

RSpec.describe User, :type => :model do
  # before(:each) do
  #   default_devise_settings!
  #   reset_ldap_server!
  # end
  #
  # describe "look up and ldap user" do
  #   it "should return true for a user that does exist in LDAP", focus: false do
  #     assert_equal true, ::Devise::LDAP::Adapter.valid_login?('example.user@test.com')
  #   end
  #
  #   it "should return false for a user that doesn't exist in LDAP", focus: false do
  #     assert_equal false, ::Devise::LDAP::Adapter.valid_login?('barneystinson')
  #   end
  # end
  before(:each) do
    CaseFinder::Setup.setup_roles
  end

  it 'knows if it does not have a role', focus: false do
    user = FactoryGirl.create(:user)
    expect(user.role?).to be_falsy
  end

  it 'knows if does have a role', focus: false do
    user = FactoryGirl.create(:user)
    user.role_assignments.build(role: Role.first)
    user.save!
    expect(user.role?).to be_truthy
  end

  it 'knows if it does not have a role because it was soft deleted', focus: false do
    user = FactoryGirl.create(:user)
    user.role_assignments.build(role: Role.first)
    user.save!
    expect(user.role?).to be_truthy
    user.role_assignments.first.soft_delete!
    expect(user.reload.role?).to be_falsy
  end

  it 'deletes absent role assignemtns', focus: false do
    user = FactoryGirl.create(:user)
    role = Role.first
    user.role_assignments.build(role: role)
    user.save!
    expect(user.role_assignments.not_deleted.find { |role_assignment| role_assignment.role == role }).to be_truthy
    user.delete_absent_role_assignments([])
    expect(user.role_assignments.not_deleted.find { |role_assignment| role_assignment.role == role }).to be_falsy
  end

  it 'does deletes present role assignemtns', focus: false do
    user = FactoryGirl.create(:user)
    role = Role.first
    user.role_assignments.build(role: role)
    user.save!
    expect(user.role_assignments.not_deleted.find { |role_assignment| role_assignment.role == role }).to be_truthy
    user.delete_absent_role_assignments([role])
    expect(user.role_assignments.not_deleted.find { |role_assignment| role_assignment.role == role }).to be_truthy
  end

  it 'builds present role assignemnts', focus: false do
    user = FactoryGirl.create(:user)
    role = Role.first
    expect(user.role_assignments.not_deleted.find { |role_assignment| role_assignment.role == role }).to be_falsy
    user.build_present_role_assignments([role])
    expect(user.role_assignments.find { |role_assignment| role_assignment.role == role }).to be_truthy
  end

  it 'does not build absent role assignemnts', focus: false do
    user = FactoryGirl.create(:user)
    role = Role.first
    expect(user.role_assignments.not_deleted.find { |role_assignment| role_assignment.role == role }).to be_falsy
    user.build_present_role_assignments([])
    expect(user.role_assignments.find { |role_assignment| role_assignment.role == role }).to be_falsy
  end

  it 'determines roles', focus: false do
    roles = Role.all
    groups = roles.map(&:external_identifier)
    expect(User.determine_roles(groups)).to match_array(roles)
  end
end