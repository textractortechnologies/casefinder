class RoleAssignment < ActiveRecord::Base
  include Abstractor::Methods::Models::SoftDelete
  has_paper_trail 
  
  belongs_to :role
  belongs_to :user
end