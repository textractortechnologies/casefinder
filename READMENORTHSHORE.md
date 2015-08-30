* get latest source for casefinder and abstractor
**  cd \
    cd \intepub\wwwroot\casefinder
    git stash
    git pull
    cd lib\abstractor
    git stash
    git pull

* Drop all the tables
** Open pgAdmin

* Open Helicon Zoo Manager
** Navigate to the casefinder application
** Click 'Start web console'

** bundle

** bundle exec rake db:migrate

** bundle exec rake abstractor:setup:system

** bundle exec rake setup:abstractor_schemas

** Add users to lib/setup/data/users.csv

** bundle exec rake setup:users

** bundle exec rake assets:precompile

* Reboot the server

* Open Helicon Zoo Manager
** Navigate to the casefinder application
** Click 'Start web console'
** bundle exec rake jobs:work

* Start Will's NLP library

** cd \
   cd \intepub\wwwroot\casefinder\lib
   java -jar text-web-service-1.0.jar

bundle exec rake setup:migrate_to_more_fine_grained_histologies
bundle exec rake setup:migrate_to_only_fine_grained_sites