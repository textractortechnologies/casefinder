# Case FInder Changelog
=======

## 1.0.0
Released on January 19, 2015

* Remove Import link from the top navigation and prevent navigation to import endpoints.
https://github.com/textractortechnologies/casefinder/issues/197

* IE does not allow for label tags in links
https://github.com/textractortechnologies/casefinder/issues/195

* Come up with a solution to make the application initialize upon reboot of the server.
https://github.com/textractortechnologies/casefinder/issues/192

* HL7 mapping of MRN is wrong.
https://github.com/textractortechnologies/casefinder/issues/190

* Always save pathology cases as new entities.
https://github.com/textractortechnologies/casefinder/issues/189

* Improve tracking of api requests.
** If successful, link the batch import to pathology case.
** Store HL7 ack in batch import.
** Make entries in the access audits.
https://github.com/textractortechnologies/casefinder/issues/188

* Force UTF-8 encoding and replace problem children in the PathologyCasesController.
https://github.com/textractortechnologies/casefinder/issues/186

* Clean HL7 before we process it.
https://github.com/textractortechnologies/casefinder/issues/182

* Encrypt password in ldap.yml
https://github.com/textractortechnologies/casefinder/issues/181

* Encrypt password in database.yml
https://github.com/textractortechnologies/casefinder/issues/180

* Upgrade to Rails 4.2.7.1
https://github.com/textractortechnologies/casefinder/issues/176

* Implement HTTP endpoint to receive pathology cases/reports
https://github.com/textractortechnologies/casefinder/issues/172

* Expand user and application level auditing
See https://github.com/textractortechnologies/casefinder/issues/167

* Implement Automatic Logoff.
https://github.com/textractortechnologies/casefinder/issues/166
