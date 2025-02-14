class User < ActiveRecord::Base
  acts_as_token_authenticatable
  has_paper_trail

  has_many :role_assignments
  has_many :roles, through: :role_assignments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :validatable, :registerable
  devise :ldap_authenticatable, :trackable, :timeoutable

  def self.determine_roles(groups)
    r = []
    if Rails.env.development?
      r = Role.all
    elsif groups.present?
      r = Role.where(external_identifier: groups)
    end
    r
  end

  def delete_absent_role_assignments(roles)
    role_assignments.not_deleted.each do |role_assignment|
      if !roles.any? { |role| role_assignment.role == role }
        role_assignment.soft_delete!
      end
    end
  end

  def build_present_role_assignments(roles)
    roles.each do |role|
      if role_assignments.not_deleted.where(role: role).empty?
        role_assignments.build(role: role)
      end
    end
  end

  def after_ldap_authentication
    groups = Devise::LDAP::Adapter.get_ldap_param(self.username, 'memberOf')
    roles = User.determine_roles(groups)
    delete_absent_role_assignments(roles)
    build_present_role_assignments(roles)
    save!
  end

  def role?
    role_assignments.not_deleted.size > 0
  end

  def has_role?(role_name)
    role_assignments.not_deleted.select { |role_assignment| role_assignment.role.name == role_name }.any?
  end
end