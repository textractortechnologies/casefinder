class User < ActiveRecord::Base
  acts_as_token_authenticatable
  has_many :role_assignments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :validatable, :registerable
  devise :ldap_authenticatable, :trackable, :timeoutable

  def self.determine_roles(groups)
    if Rails.env == 'development'
      Role.all
    else
      Role.where(external_identifier: groups)
    end
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
end