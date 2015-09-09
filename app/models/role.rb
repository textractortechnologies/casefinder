class Role < ActiveRecord::Base
  include Abstractor::Methods::Models::SoftDelete
  has_many :role_assignments
end