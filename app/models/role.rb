class Role < ActiveRecord::Base
  include Abstractor::Methods::Models::SoftDelete
  has_paper_trail 
  
  has_many :role_assignments
end