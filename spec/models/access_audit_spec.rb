require 'rails_helper'

RSpec.describe AccessAudit, type: :model do
  it { is_expected.to validate_presence_of :action } 
  it { is_expected.to validate_inclusion_of(:action).in_array(AccessAudit.allowed_actions) }
end
