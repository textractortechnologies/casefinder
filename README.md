# casefinder

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
* bundle exec rake abstractor:setup:system
* bundle exec rake setup:abstractor_schemas
* bundle exec rake setup:pathology_cases
* http://casefinder.dev/
