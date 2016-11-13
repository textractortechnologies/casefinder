1. Install Windows Server 2012 64bit.
2. Install IIS
  1. Add Roles
  2. Web Server (IIS)
  3. Check all install option except the except
    1. &#39;IIS6 Management Compatibility&#39;
3. Turn on automatic updates.
4. Install all updates.
5. Install Ruby
  1. [http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.5-x64.exe](http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.5-x64.exe)
  2. Check Add Ruby executables to your PATH.
  3. Associate .rb and .rbw files with this Ruby installation.
6. Install Ruby Development Kit
  1. Install Development Kit: [http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe](http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe)
  2. Copy or extract the devkit (you will have to create this folder) extracted files into c:\Ruby21-x64\devkit.
  3. Open Start|All Programs|Ruby 2.1.5-p273-x64 |Start Command Prompt with Ruby
  4. Execute &#39;cd C:\Ruby21-x64\DevKit&#39; on command prompt.
  5. Execute &#39;ruby dk.rb init&#39;  on command prompt.
  6. Execute &#39;ruby dk.rb review&#39; on command prompt.
  7. Edit &#39;C:\Ruby21-x64\DevKit\config.yml&#39;
  8. Enter &#39;- C:/Ruby21-x64&#39; at the end the &#39;C:\Ruby21-x64\DevKit\config.yml&#39;
  9. Execute &#39;ruby dk.rb install&#39; on command prompt.
7. Install Windows Github client: [https://windows.github.com/](https://windows.github.com/)
8. Clone the casefinder Github repository to c:\inetpub\wwwroot\casefinder  This is a private repository.  To clone, you must provide Textractor Technologies collaborator credentials: Will Thompson or Michael Gurley.
9. Clone the abstractor Github repository to c:\inetpub\wwwroot\casefinder\lib\abstractor This is a private repository.  To clone, you must provide Textractor Technologies collaborator credentials: Will Thompson or Michael Gurley.
10. Copy the .pem file C:/Ruby21/lib/ruby/2.1.0/rubygems/ssl\_certs/AddTrustExternalCARoot-2048.pem.  See file &#39;AddTrustExternalCARoot-2048.pem file&#39;.
11. Install the 64bit Java JDK to C:\Program Files\Java\jdk1.8.0\_102.   [http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
12. Install Node.js: [https://nodejs.org/](https://nodejs.org/).
13. Install MySQL.
  1. [http://www.mysql.com/downloads/](http://www.mysql.com/downloads/).
  2. Install MySQL Workbench [https://dev.mysql.com/downloads/workbench/](https://dev.mysql.com/downloads/workbench/).
  3. Create &#39;casefinder&#39; schema.
  4. Create &#39;casefinder&#39; user.
  5. Grant all roles and all privileges to &#39;caserfinder&#39; user to &#39;casefinder&#39; schema.
  6. Change password in c:\inetpub\wwwroot\casefinder\config\database.yml
14. Install the web platform installer 5.0 and Hellicon Zoo: [http://www.microsoft.com/web/downloads/platform.aspx](http://www.microsoft.com/web/downloads/platform.aspx)
  1. Add the custom feed of [http://www.helicontech.com/zoo/feed.xml](http://www.helicontech.com/zoo/feed.xml)
    1. Run the web platform installer 5.0
    2. Click &#39;Options&#39;
    3. Add the link to Helicon Zoo Feed &#39;http://www.helicontech.com/zoo/feed.xml&#39; into the &#39;Custom Feeds&#39; text box.
    4. Click &#39;Add feed&#39;
    5. Click &#39;IIS&#39; for the question &#39;Which Web Server would you like to use?&#39;
    6. Click &#39;OK&#39; button.
    7. After adding custom feed new Zoo tab will appear with Applications, Templates, Packages, Modules and Engines sections in it.
    8. Click the &#39;Add&#39; button next to &#39;Ruby 2.0&#39; and click the &#39;Install&#39; button.
    9. At the end of the install it will end on the Configure section, just accept the default options.
    10. Close the web installer when done.
    11. Open Start|All Programs|Hellicon|Zoo|Hellicon Zoo Manager
    12. Click &quot;applicationHost.config&quot; (It&#39;s a tab at the top).
    13. Find the engines tag and add a new user engine at the after &lt;\engines&gt;. Make sure to save the change and choose refresh at the top of the window then close.  See file &#39;applicationHost.config&#39;.
    14. A user engine should be added any time a new version of ruby comes out.
    15. Close the Hellicon Zoo Manager.
15. Add an application to IIS
  1. Open Start|All Programs|Administrative Tools|Internet Information Services (IIS) Manager
  2. In IIS right click default website and add application. The alias should be all lower case.  Set the physical path to &#39;C:\inetpub\wwwroot\casefinder&#39;.
  3. Set the proper rights to the folder. Grant write access to &quot;IIS\_IUSRS&quot; to the folder. This should be temporary and removed once you are done with configuration.
16. Add an application to Hellicon Zoo
  1. Open Start|All Programs|Hellicon|Zoo|Hellicon Zoo Manager
  2. Click on the &#39;casefinder&#39; application in Helicon Zoo Manager under &#39;Default Web Site&#39;
  3. In the &#39;Applications&#39; section, click the &#39;New&#39; button.
  4. Name it &#39;Ruby2.1.rack&#39;.
  5. Select the engine that was created in the config file: &#39;ruby.2.1.x64.rack&#39;.
  6. Ensure you have the environment variables
    1. RACK\_ENV=production
    2. RAILS\_RELATIVE\_URL\_ROOT=%APPL\_VIRTUAL\_PATH%
    3. SECRET\_KEY\_BASE
  7. The variables should of been copied over from the custom engine that was added.
  8. In the &#39;Environment Variables&#39; section, click the button &#39;New&#39;.
  9. Set the &#39;Name&#39; to &#39;JAVA\_HOME&#39; and the &#39;Value&#39; to &#39;C:\Program Files\Java\jdk1.8.0\_102&#39;  and click &#39;OK&#39;.
  10. Click &#39;Apply&#39; button and the next &#39;Apply&#39; button.
  11. Click your &#39;Case Finder&#39; in the site list on the far left, this will cause Helicon Zoo to refresh enabling the Web Console.
  12. Click the button &#39;Start web console&#39;.
  13. At the Web console type &#39;gem install bundler&#39;.
  14. At the Web console type &#39;bundle install&#39;.
  15. .At the Web console type &#39;bundle exec rake db:migrate&#39;.
  16. At the Web console type &#39;bundle exec rake abstractor:setup:system&#39;.
  17. At the Web console type &#39;bundle exec rake setup:abstractor\_schemas&#39;.
  18. At the Web console type &#39;bundle exec rake setup:roles&#39;.
  19. At the Web console type &#39;bundle exec rake assets:precompile&#39;.
17. Deploy Rails secrets.yml
  1. Open Start|All Programs|Hellicon|Zoo|Hellicon Zoo Manager
  2. Click on the &#39;casefinder&#39; application in Helicon Zoo Manager under &#39;Default Web Site&#39;
  3. Click the button &#39;Start web console&#39;.
  4. Type &#39;bundle exec rake secret&#39; at console.
  5. Place output into &#39;C:\inetpub\wwwroot\casefinder\config\secrets.yml file&#39;.
18. Deploy batch jobs
  1. Copy &#39;casefinder.cmd&#39; to Desktop.  See file &#39;casefinder.cmd&#39;
  2. Copy &#39;nlp.cmd&#39; to Desktop.  See file &#39;nlp.cmd&#39;
19. SFTP transfer of PowerPath files (Pending work with NorthShore).
20. LDAP configuration (Entries pending work with NorthShore).
  1. Set entries in &#39;C:\inetpub\wwwroot\casefinder\config\ldap.yml&#39;. in the production environment block for:
    1. host:
    2. port:
    3. attribute:
    4.  base:
    5. admin\_user:
    6. admin\_password:
    7. ssl:
21. SMTP configuration (for exception notification to application support)
  1. Set entries in &#39;C:\inetpub\wwwroot\casefinder\config\ldap.yml&#39;. in the production environment block for:
    1.  config.action\_mailer.delivery\_method = :smtp
    2. config.action\_mailer.smtp\_settings = { address: ? , port: ? }