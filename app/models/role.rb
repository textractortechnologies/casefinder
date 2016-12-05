class Role < ActiveRecord::Base
  ROLE_CASEFINDER_API = 'CASEFINDER_API'
  include Abstractor::Methods::Models::SoftDelete
  has_paper_trail 
  
  has_many :role_assignments
end