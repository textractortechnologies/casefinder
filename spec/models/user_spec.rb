require 'rails_helper'

RSpec.describe User, :type => :model do
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

  it 'knows if a user has a role', focus: false do
    user = FactoryGirl.create(:user)
    role = Role.where(name: Role::ROLE_CASEFINDER_USER).first
    user.role_assignments.build(role: role)
    user.save!
    expect(user.has_role?(Role::ROLE_CASEFINDER_USER)).to be_truthy
  end

  it 'knows if a user does not have a role', focus: false do
    user = FactoryGirl.create(:user)
    role = Role.where(name: Role::ROLE_CASEFINDER_ADMIN).first
    user.role_assignments.build(role: role)
    user.save!
    expect(user.has_role?(Role::ROLE_CASEFINDER_USER)).to be_falsy
  end

  it 'knows if a user does not have a role even if it is soft deleted', focus: false do
    user = FactoryGirl.create(:user)
    role = Role.where(name: Role::ROLE_CASEFINDER_USER).first
    user.role_assignments.build(role: role)
    user.save!
    expect(user.has_role?(Role::ROLE_CASEFINDER_USER)).to be_truthy
    user.role_assignments.where(role: role).first.soft_delete!
    expect(user.reload.has_role?(Role::ROLE_CASEFINDER_USER)).to be_falsy
  end
end