Feature: Listing and reviewing pathology cases
  User should be able to list, search and navigate to pathology cases

  Background: Everything is setup
    Given abstraction schemas are setup
    And roles are setup

  @javascript
  Scenario: Searching and listing pathology cases
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    And I visit the pathology cases index page
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    And the "Reviewed?" select should have "pending" selected
    And the "Flagged?" select should have "flagged" selected
    When I select "not flagged" from "Flagged?"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 124              | 02/01/2015       |                         |                 |
    When I select "all" from "Flagged?"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 124              | 02/01/2015       |                         |                 |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I fill in "Search" with "pleomorphic carcinoma (8022/3)"
    And I select "flagged" from "Flagged?"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I fill in "Search" with "external lip, nos (c00.2)"
    And I select "flagged" from "Flagged?"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
    When I fill in "Search" with "lip"
    Then I should see "external upper lip (c00.0)" within ".ui-autocomplete"
    And I should see "external lower lip (c00.1)" within ".ui-autocomplete"
    And I should see "external lip, nos (c00.2)" within ".ui-autocomplete"
    And I should see "mucosa of upper lip (c00.3)" within ".ui-autocomplete"
    And I should see "mucosa of lower lip (c00.4)" within ".ui-autocomplete"
    And I should see "mucosa of lip, nos (c00.5)" within ".ui-autocomplete"
    And I should see "commissure of lip (c00.6)" within ".ui-autocomplete"
    And I should see "overlapping lesion of lip (c00.8)" within ".ui-autocomplete"
    And I should see "lip, nos (c00.9)" within ".ui-autocomplete"
    And I should not see "upper gum (c03.0)" within ".ui-autocomplete"
    And I should not see "lower gum (c03.1)" within ".ui-autocomplete"
    And I should not see "gum, nos (c03.9)" within ".ui-autocomplete"
    When I fill in "Search" with "gum"
    And I wait 2 seconds
    Then I should not see "external upper lip (c00.0)" within ".ui-autocomplete"
    And I should not see "external lower lip (c00.1)" within ".ui-autocomplete"
    And I should not see "external lip, nos (c00.2)" within ".ui-autocomplete"
    And I should not see "mucosa of upper lip (c00.3)" within ".ui-autocomplete"
    And I should not see "mucosa of lower lip (c00.4)" within ".ui-autocomplete"
    And I should not see "mucosa of lip, nos (c00.5)" within ".ui-autocomplete"
    And I should not see "commissure of lip (c00.6)" within ".ui-autocomplete"
    And I should not see "overlapping lesion of lip (c00.8)" within ".ui-autocomplete"
    And I should not see "lip, nos (c00.9)" within ".ui-autocomplete"
    And I should see "upper gum (c03.0)" within ".ui-autocomplete"
    And I should see "lower gum (c03.1)" within ".ui-autocomplete"
    And I should see "gum, nos (c03.9)" within ".ui-autocomplete"
    When I fill in "Search" with "large"
    And I select "flagged" from "Flagged?"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
    When I fill in "Search" with "gum"
    And I select "flagged" from "Flagged?"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I visit the pathology cases index page
    Then the "Collected" radio button should be checked
    And the "Imported" radio button should not be checked
    When I select "all" from "Flagged?"
    And I fill in "From" with "2015-01-15"
    And I fill in "To" with "2015-04-01"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 124              | 02/01/2015       |                         |                 |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I visit the pathology cases index page
    When I select "all" from "Flagged?"
    And I choose the "Imported" radio button
    And I fill in "From" with "today"
    And I fill in "To" with "tomorrow"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 124              | 02/01/2015       |                         |                 |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I click "Accession Number" within ".pathology_cases_list"
    Then I should see pathology cases with the following information in order
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 124              | 02/01/2015       |                         |                 |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I click "Accession Number" within ".pathology_cases_list"
    Then I should see pathology cases with the following information in order
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
      | 124              | 02/01/2015       |                         |                 |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
    When I click "Collection Date" within ".pathology_cases_list"
    Then I should see pathology cases with the following information in order
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 124              | 02/01/2015       |                         |                 |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I click "Collection Date" within ".pathology_cases_list"
    Then I should see pathology cases with the following information in order
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
      | 124              | 02/01/2015       |                         |                 |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
    When I click "Suggested Histologies" within ".pathology_cases_list"
    Then I should see pathology cases with the following information in order
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 124              | 02/01/2015       |                         |                 |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I click "Suggested Histologies" within ".pathology_cases_list"
    Then I should see pathology cases with the following information in order
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 124              | 02/01/2015       |                         |                 |
    When I click "Suggested Sites" within ".pathology_cases_list"
    Then I should see pathology cases with the following information in order
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 124              | 02/01/2015       |                         |                 |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I click "Suggested Sites" within ".pathology_cases_list"
    Then I should see pathology cases with the following information in order
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
      | 124              | 02/01/2015       |                         |                 |
    When I visit the pathology cases index page

  @javascript
  Scenario: Listing pathlogy cases after submitting a case to METRIQ
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    And I visit the pathology cases index page
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When click "Review" for accession number "123"
    And I wait 1 seconds
    And I check "carcinoma, nos (8010/3)" within ".has_cancer_histology"
    And I check "base of tongue, nos (c01.9)" within ".has_cancer_site"
    And I click the "Submit to METRIQ" button
    And I wait 2 seconds
    Then I should be on the edit page of accession number "125"
    When I click "Previous Case" within ".pathology_case_header_actions"
    And I wait 2 seconds
    Then I should be on the edit page of accession number "123"
    When I visit the pathology cases index page
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I select "submitted" from "Reviewed?"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |

  @javascript
  Scenario: Listing pathlogy cases after discarding a case
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    And I visit the pathology cases index page
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When click "Review" for accession number "123"
    And I wait 1 seconds
    And I click "Discard Case" within ".pathology_case_footer_actions"
    And I wait 2 seconds
    Then I should be on the edit page of accession number "125"
    When I click "Previous Case" within ".pathology_case_header_actions"
    And I wait 2 seconds
    Then I should be on the edit page of accession number "123"
    When I visit the pathology cases index page
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When I select "discarded" from "Reviewed?"
    And I click the "Search" button
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |

  @javascript
  Scenario: Moving to the next case and the previous case
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    And I visit the pathology cases index page
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When click "Review" for accession number "123"
    And I wait 1 seconds
    And I click "Next Case" within ".pathology_case_footer_actions"
    And I wait 2 seconds
    Then I should be on the edit page of accession number "125"
    When I click "Previous Case" within ".pathology_case_header_actions"
    And I wait 2 seconds
    Then I should be on the edit page of accession number "123"
    When I click "Next Case" within ".pathology_case_footer_actions"
    And I wait 2 seconds
    Then I should be on the edit page of accession number "125"
    When I click "Next Case" within ".pathology_case_footer_actions"
    And I wait 2 seconds
    Then I should be on the edit page of accession number "123"

  @javascript
  Scenario: Viewing the details of a pathology case
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                          | Patient         | MRN   | SSN | Birth Date | Sex | Attending    |  Surgeon      |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   | Harold Baines   | 999   | 666 | 01/01/1970 | M   | Jones, Bob   |  Smith, Barry |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        | Paul Konerko    | 888   | 555 | 01/01/1980 | M   | Jones, Mary  |  Smith, Norm  |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               | Minnie Minoso   | 777   | 444 | 01/01/1960 | M   | Jones, Sam   |  Smith, Nancy |
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    And I visit the pathology cases index page
    Then I should see pathology cases with the following information
      | Accession Number | Collection Date  | Suggested Histologies   | Suggested Sites |
      | 123              | 01/01/2015       | carcinoma, nos (8010/3)&large cell carcinoma, nos (8012/3) | base of tongue, nos (c01.9)&external lip, nos (c00.2)&lip, nos (c00.9)&tongue, nos (c02.9) |
      | 125              | 03/01/2015       | carcinoma, nos (8010/3)&pleomorphic carcinoma (8022/3)     | gum, nos (c03.9)&lower gum (c03.1)                                                         |
    When click "Review" for accession number "123"
    Then I should see "01/01/2015" within ".collection_date"
    And I should see "123" within ".accession_number"
    And I should see "Harold Baines" within ".patient_full_name"
    And I should see "999" within ".mrn"
    And I should see "666" within ".ssn"
    And I should see "01/01/1970" within ".birth_date"
    And I should see "M" within ".sex"
    And I should see "Jones, Bob" within ".attending"
    And I should see "Smith, Barry" within ".surgeon"