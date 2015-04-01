# casefinder

* bundle exec cap production deploy

* bundle exec cap production secrets_yml:setup

* bundle exec rake db:migrate

* sudo -su root

* cd /vagrant

* cp stanford-core-nlp/*.* /usr/local/stanford-core-nlp/

* RAILS_ENV=production rvm 2.2 do bundle exec rake abstractor:setup:system

* RAILS_ENV=production rvm 2.2 do bundle exec rake setup:abstractor_schemas

* RAILS_ENV=production rvm 2.2 do bundle exec rake setup:pathology_cases

* RAILS_ENV=production rvm 2.2 do bin/delayed_job start

* RAILS_ENV=production rvm 2.2 do bundle exec rails console

* http://casefinder.dev/

* Debugging server issues
** sudo -su root
** cd /var/log/httpd/


* in deploy directory: rvm 2.2 do  bundle config build.pg --with-pg-config=/usr/pgsql-9.4/bin/pg_config

git checkout --track origin/\#13
git submodule update --init --recursive


Ok, so I tried a physical connection at home.   This time it worked.
With auto_config commented out.
Then I did a vagrant halt, a vagrant up.
Got the error you had today.  So then I did a vagrant halt.
Then uncommented the auto_config line.
Then a vagrant up.  No error.
And I can ping casefinder.local.
So I guess that is the workaround for right now.
I will try to deploy the app and let you know how it goes.

vagrant box add mgurley/casefinder --provider virtualbox
vagrant up casefinder
vagrant ssh
ping casefinder.local

vagrant login
vagrant box update

bundle exec rails g abstractor:install --customize-controllers --no-install-stanford-core-nlp
http://casefinder.dev/abstractor_abstraction_schemas/1.json