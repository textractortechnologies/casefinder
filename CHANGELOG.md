# Case Finder Changelog
=======
## 1.1.3
Released on May 7, 2017

* Only allow 'admins' to view and visit the dictionary maintenance pages.
https://github.com/textractortechnologies/casefinder/issues/227

* Create a link between the value variant and the suggestion.
https://github.com/textractortechnologies/casefinder/issues/225

* Fix display of label/delete button on variant values for adding/editing an abstractor object value.
https://github.com/textractortechnologies/casefinder/issues/224

* Authenticate and authorize the Rules resource.
https://github.com/textractortechnologies/casefinder/issues/223

* Do not find soft deleted suggestions when searching pathology cases by suggestions.
https://github.com/textractortechnologies/casefinder/issues/222

* Do not display soft deleted suggestions on pathology cases index page.
https://github.com/textractortechnologies/casefinder/issues/221

* Allow accepted values belonging to deleted object values to be re-exported.
https://github.com/textractortechnologies/casefinder/issues/220

* Create rules engine to retrieve and process rules and perform operations on generated suggestions based on the rules.
https://github.com/textractortechnologies/casefinder/issues/219

* Expire NLP schema cache if update timestamp is out of date via post.
https://github.com/textractortechnologies/casefinder/issues/218

*Post update timestamp for each schema along with schemas accompanying note.
https://github.com/textractortechnologies/casefinder/issues/217

* Create UI to maintain the dictionary objects and variants.
https://github.com/textractortechnologies/casefinder/issues/216

* Create new rules resource that accepts an array of schemas and returns all the rules associated with the schemas.
https://github.com/textractortechnologies/casefinder/issues/213

* Change posting of note and schema be all at once per note.
https://github.com/textractortechnologies/casefinder/issues/212

* Allow dictionary items to be marked as case sensitive.
https://github.com/textractortechnologies/casefinder/issues/211

## 1.1.2
Released on Feburary 20, 2017

* Map from mrn to cpi instead of cpi to mrn.
https://github.com/textractortechnologies/casefinder/issues/209

## 1.1.1
Released on Feburary 17, 2017

* If we can't map to the desired patient identifier, then leave mrn null/blank.
https://github.com/textractortechnologies/casefinder/issues/208

* Add checks for integrity or order messages to maintenance:integrity_check rake task.
https://github.com/textractortechnologies/casefinder/issues/207

## 1.1.0
Released on Feburary 16, 2017

* Don't send the orphan sweep email if no orphans were found.
https://github.com/textractortechnologies/casefinder/issues/206


* Improve error handling in maintenance rake tasks to log/notify if a problem occurs.
https://github.com/textractortechnologies/casefinder/issues/205


* Implement HTTP endpoint to receive pathology cases/reports orders.
https://github.com/textractortechnologies/casefinder/issues/203


* Deleting site/histology parings is not working.  Change IIS settings.
https://github.com/textractortechnologies/casefinder/issues/202

## 1.0.0
Released on January 19, 2017

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
