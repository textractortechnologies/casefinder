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

* RAILS_ENV=production rvm 2.2.0 do bundle exec rake setup:users

* sudo -su root

* java -jar text-web-service-1.0.jar

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

#windows vm
* Download windows 180 evaluation:  http://www.microsoft.com/en-us/download/details.aspx?id=11093
* Virtual Box|Machine|New Choose
** Version Windows 2008 (64 bit)
** Memory Size: 9216 MB
** Create a virtual hard drive now
** VHD(Virtaual Hard Disk)
** Dynamically allocated 30GB
** Install Windows 2008 R2 Enterprise (Full Installation)
** Networking: bridged
** Set administrator password: Rorty1971
* Install IIS
** All Programs|Administrative Tools|Server Manager
** Roles
** Add Roles
** Web Server (IIS)
** Check just about every install option except the IIS6 stuff
* Turn on automatic updates.  Get them all.
* Install Firefox.
* http://www.codeproject.com/Tips/805628/Ruby-on-Rails-On-Windows-Server-With-Helicon-Zoo
* Install Ruby from http://rubyinstaller.org/
** Install Ruby 2.1.5: http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.5-x64.exe
** Check Add Ruby executables to your PATH.
** Assocaite .rb and .rbw files with this Ruby installation.
** Install Development Kit: http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe
* Follow steps 3-7 in http://www.codeproject.com/Tips/805628/Ruby-on-Rails-On-Windows-Server-With-Helicon-Zoo
* Install Windows github client: https://windows.github.com/
* Close the casefinder Github repository to c:\inetpub\wwwroot\
* Install SSL certificate: http://stackoverflow.com/questions/19150017/ssl-error-when-installing-rubygems-unable-to-pull-data-from-https-rubygems-o/27298259#27298259
* Download https://raw.githubusercontent.com/rubygems/rubygems/master/lib/rubygems/ssl_certs/AddTrustExternalCARoot-2048.pem
* Copy the .pem C:/Ruby21/lib/ruby/2.1.0/rubygems/ssl_certs/
* gem install bundler
* bundle
* Install Java.
* Set Java environemnt variables: http://www.artonx.org/collabo/backyard/?HowToBuildRjb
** Set JAVA_HOME=root of the JDK directory
** Add %JAVA_HOME%bin to PATH
* Install PostgreSQL
* Create casefinder login
** Check role privileges: Can login, Inherits rights from parent roles, Superuser, Can create databases, Can modify catalog directly
* Change password in database.yml
* Download Stanford Core NLP: http://nlp.stanford.edu/software/corenlp.shtml
** Unzip and instal into "#{Rails.root}/lib/stanford-core-nlp/"
* Download https://github.com/louismullie/stanford-core-nlp
** Unzip and move contents of bin folder into "#{Rails.root}/lib/stanford-core-nlp/"
* Deploy secrets.yml file with production.
* Set config.relative_url_root = "/casefinder"
* Install NodeJs: https://nodejs.org/
* bundle exec rake assets:precompile
* bundle exec rake jobs:work