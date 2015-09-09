class RoleAssignment < ActiveRecord::Base
  include Abstractor::Methods::Models::SoftDelete
  belongs_to :role
  belongs_to :user
end