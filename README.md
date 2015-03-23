# casefinder

* in deploy directory: rvm 2.2 do  bundle config build.pg --with-pg-config=/usr/pgsql-9.4/bin/pg_config
### Deployment for development
Tested with the following versions:
* Vagrant 1.7.2
* VirtualBox 4.3.22
  * VirtualBox Extensions Pack
* An internet connection to retrieve and install dependencies

1. Clone the repository.
2. Initialize submodules  ``git submodule init``
3. Clone and check out submodules ``git submodule update``

Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
=======
* bundle exec rake db:migrate
* RAILS_ENV=production rvm 2.2 do bundle exec rake abstractor:setup:system
* RAILS_ENV=production rvm 2.2 do bundle exec rake setup:abstractor_schemas
* RAILS_ENV=production rvm 2.2 do bundle exec rake setup:pathology_cases
* RAILS_ENV=production rvm 2.2 do bundle exec rails console
* RAILS_ENV=production rvm 2.2 do bin/delayed_job start
* http://casefinder.dev/