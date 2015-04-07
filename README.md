# casefinder

## Deployment of VM

* Vagrant 1.7.2

* VirtualBox 4.3.22

* VirtualBox Extensions Pack

* An internet connection to retrieve and install dependencies

* git clone git@github.com:mgurley/casefinder.git

* cd casefinder

* git submodule update --init --recursive

* comment out Vagrant file auto_config: false

* vagrant up

* vagrant halt

* uncomment out Vagrant file auto_config: false

* vagrant up

* bundle exec cap production deploy

* bundle exec cap production secrets_yml:setup

* vagrant ssh

* sudo -su root

* yum install nano

* sudo -su root

* cd /vagrant/lib

* cp stanford-core-nlp/*.* /usr/local/stanford-core-nlp/

* cd /var/www/apps/casefinder/current

* RAILS_ENV=production rvm 2.2.0 do bundle exec rake abstractor:setup:system

* RAILS_ENV=production rvm 2.2.0 do bundle exec rake setup:abstractor_schemas

* RAILS_ENV=production rvm 2.2.0 do bundle exec rake setup:pathology_cases

* sudo -su root

* RAILS_ENV=production rvm 2.2.0 do bin/delayed_job start

# Debug server issues
* vagrant ssh
* sudo -su root
* cd /var/log/httpd/

# Add a versioned vagrant box
* vagrant login
* vagrant box add mgurley/casefinder --provider virtualbox
* vagrant up casefinder
* vagrant ssh
* vagrant box update

# Miscellaneous

* in deploy directory: rvm 2.2.0 do  bundle config build.pg --with-pg-config=/usr/pgsql-9.4/bin/pg_config
* git checkout --track origin/\#13
* git submodule update --init --recursive
* http://casefinder.dev/
* RAILS_ENV=production rvm 2.2.0 do bundle exec rails console
* in deploy directory: rvm 2.2.0 do  bundle config build.pg --with-pg-config=/usr/pgsql-9.4/bin/pg_config
* ping casefinder.local
* bundle exec rails g abstractor:install --customize-controllers --no-install-stanford-core-nlp
* http://casefinder.dev/abstractor_abstraction_schemas/1.jso
* rvm all do gem list