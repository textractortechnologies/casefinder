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
** Set administrator password:
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
** Associate .rb and .rbw files with this Ruby installation.
** Install Development Kit: http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe
* Follow steps 3-7 in http://www.codeproject.com/Tips/805628/Ruby-on-Rails-On-Windows-Server-With-Helicon-Zoo
* Install Windows github client: https://windows.github.com/
* Clone the casefinder Github repository to c:\inetpub\wwwroot\casefinder  This is a private repository.  To clone, you must provide collaborator credentials:Will Thompson or Michael Gurley.
* Clone the abstractor Github repository to c:\inetpub\wwwroot\casefinder\lib\abstractor This is a private repository.  To clone, you must provide ccollaborator credentials: Will Thompson or Michael Gurley.
* Install SSL certificate: http://stackoverflow.com/questions/19150017/ssl-error-when-installing-rubygems-unable-to-pull-data-from-https-rubygems-o/27298259#27298259
* Download https://raw.githubusercontent.com/rubygems/rubygems/master/lib/rubygems/ssl_certs/AddTrustExternalCARoot-2048.pem
* Copy the .pem C:/Ruby21/lib/ruby/2.1.0/rubygems/ssl_certs/
* Open Helicon Zoo Manager
** Navigate to the casefinder application
** Click 'Start web console'
** gem install bundler
** bundle update
* Install Java.
* Set Java environemnt variables: http://www.artonx.org/collabo/backyard/?HowToBuildRjb
** Set JAVA_HOME=root of the JDK directory
** Add %JAVA_HOME%bin to PATH
* Install MySQL
** Create casefinder schema.
** Create casefinder user.  Grant all roles.  Grant all privileges to caserfinder user to casefinder schema.
**  Change password in c:\inetpub\wwwroot\casefinder\config\database.yml
* Deploy secrets.yml
** Create file c:\inetpub\wwwroot\casefinder\config\secrets.yml
** Navigate to the casefinder application
** Click 'Start web console'
** bundle exec rake seceret
** place output into secrets.yml file
  production:
    secret_key_base:
* Install NodeJs: https://nodejs.org/
* Open Helicon Zoo Manager
** Navigate to the casefinder application
** Click 'Start web console'
** bundle exec rake db:migrate
** bundle exec rake abstractor:setup:system
** bundle exec rake setup:abstractor_schemas
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