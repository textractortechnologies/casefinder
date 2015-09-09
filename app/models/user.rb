class User < ActiveRecord::Base
  acts_as_token_authenticatable
  has_many :role_assignments
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :validatable, :registerable
  devise :ldap_authenticatable, :trackable, :timeoutable

  def after_ldap_authentication
    groups = Devise::LDAP::Adapter.get_ldap_param(self.username, 'memberOf')
    roles = Role.where(external_identifier: groups)
    # roles = Role.all
    # roles = []

    role_assignments.not_deleted.each do |role_assignment|
      if !roles.any? { |role| role_assignment.role == role }
        role_assignment.soft_delete!
      end
    end

    save!

    roles.each do |role|
      if role_assignments.not_deleted.where(role: role).count == 0
        role_assignments.build(role: role)
      end
    end

    save!
  end

  def role?
    role_assignments.not_deleted.size > 0
  end
end