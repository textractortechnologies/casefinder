# casefinder

* in deploy directory: rvm 2.2 do  bundle config build.pg --with-pg-config=/usr/pgsql-9.4/bin/pg_config
* bundle exec rake db:migrate
* RAILS_ENV=production rvm 2.2 do bundle exec rake abstractor:setup:system
* RAILS_ENV=production rvm 2.2 do bundle exec rake setup:abstractor_schemas
* RAILS_ENV=production rvm 2.2 do bundle exec rake setup:pathology_cases
* RAILS_ENV=production rvm 2.2 do bundle exec rails console
* RAILS_ENV=production rvm 2.2 do bin/delayed_job start
* http://casefinder.dev/