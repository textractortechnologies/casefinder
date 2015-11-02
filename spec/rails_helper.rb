# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require './lib/case_finder/setup/'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

def ldap_root
  File.expand_path('ldap', File.dirname(__FILE__))
end

def ldap_connect_string
  if ENV["LDAP_SSL"]
    "-x -H ldaps://localhost:3389 -D 'cn=admin,dc=test,dc=com' -w secret"
  else
    "-x -h localhost -p 3389 -D 'cn=admin,dc=test,dc=com' -w secret"
  end
end

def reset_ldap_server!
  if ENV["LDAP_SSL"]
    `ldapmodify #{ldap_connect_string} -f #{File.join(ldap_root, 'clear.ldif')}`
    `ldapadd #{ldap_connect_string} -f #{File.join(ldap_root, 'base.ldif')}`
  else
    `ldapmodify #{ldap_connect_string} -f #{File.join(ldap_root, 'clear.ldif')}`
    `ldapadd #{ldap_connect_string} -f #{File.join(ldap_root, 'base.ldif')}`
  end
end

def default_devise_settings!
  ::Devise.ldap_logger = true
  ::Devise.ldap_create_user = false
  ::Devise.ldap_update_password = true
  ::Devise.ldap_config = "#{Rails.root}/config/#{"ssl_" if ENV["LDAP_SSL"]}ldap.yml"
  ::Devise.ldap_check_group_membership = false
  ::Devise.ldap_check_attributes = false
  ::Devise.ldap_auth_username_builder = Proc.new() {|attribute, login, ldap| "#{attribute}=#{login},#{ldap.base}" }
  ::Devise.authentication_keys = [:email]
end