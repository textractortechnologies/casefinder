class Role < ActiveRecord::Base
  ROLE_CASEFINDER_API = 'CASEFINDER_API'
  ROLE_CASEFINDER_USER = 'CASEFINDER_USER'
  ROLE_CASEFINDER_ADMIN = 'CASEFINDER_ADMIN'
  ROLES = [ROLE_CASEFINDER_API, ROLE_CASEFINDER_USER, ROLE_CASEFINDER_ADMIN]

  include Abstractor::Methods::Models::SoftDelete
  has_paper_trail

  has_many :role_assignments
end