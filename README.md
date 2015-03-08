# casefinder

* bundle exec rake db:migrate
* RAILS_ENV=production rvm 2.2 do bundle exec rake abstractor:setup:system
* RAILS_ENV=production rvm 2.2 do bundle exec rake setup:abstractor_schemas
* RAILS_ENV=production rvm 2.2 do bundle exec rake setup:pathology_cases
* RAILS_ENV=production rvm 2.2 do bundle exec rails console
* http://casefinder.dev/
