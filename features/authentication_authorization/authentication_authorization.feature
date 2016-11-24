Feature: Authenticating and authorizing access
  User should be able to access authorized resources if authenticated

  Background: Everything is setup
    Given abstraction schemas are setup
    And roles are setup

  @javascript
  Scenario: Visiting pages authenticated and authorized
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    And "example.user@test.com" is authorized
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    Then the "AccessAudit" records should match
    | username              | action                           |
    | example.user@test.com | VALUE: AccessAudit.login_success |
    When I visit the pathology cases index page
    Then I should be on the pathology cases index page
    When I visit the review page for accession number "123"
    And I wait 1 seconds
    Then I should be on the edit page of accession number "123"
    When I visit the new import page
    Then I should be on the new import page
    When I visit the new export page
    Then I should be on the new export page

  @javascript
  Scenario: Visiting pages because not authenticated
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    And "example.user@test.com" is authorized
    When "example.user@test.com" logs in with password "wrong"
    And I wait 1 seconds
    Then I should be on the sign in page
    And the "AccessAudit" records should match
    | username              | action                           |
    | example.user@test.com | VALUE: AccessAudit.login_failure |
    And I should see "Invalid username or password." within "#alert"
    When I visit the pathology cases index page
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing." within "#alert"
    When I visit the new import page
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing." within "#alert"
    When I visit the new export page
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing." within "#alert"

  @javascript
  Scenario: Visiting pages authenticated but not authorized
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    And "example.user@test.com" is not authorized
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    Then I should be on the home page
    And I should see "Signed in successfully." within "#notice"
    And the "AccessAudit" records should match
    | username              | action                           |
    | example.user@test.com | VALUE: AccessAudit.login_success |
    When I visit the pathology cases index page
    And I wait 1 seconds
    Then I should be on the home page
    And the "AccessAudit" records should match
    | username              | action                                         | description                  |
    | example.user@test.com | VALUE: AccessAudit.login_success               |                              |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt | pathology_case_policy.index? |
    And I should see "You are not authorized to perform this action." within "#alert"
    When I visit the new import page
    Then I should be on the home page
    And I should see "You are not authorized to perform this action." within "#alert"
    And the "AccessAudit" records should match
    | username              | action                                         | description                  |
    | example.user@test.com | VALUE: AccessAudit.login_success               |                              |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt | pathology_case_policy.index? |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt | batch_import_policy.new?     |
    When I visit the new export page
    Then I should be on the home page
    And I should see "You are not authorized to perform this action." within "#alert"
    And the "AccessAudit" records should match
    | username              | action                                         | description                  |
    | example.user@test.com | VALUE: AccessAudit.login_success               |                              |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt | pathology_case_policy.index? |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt | batch_import_policy.new?     |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt | batch_export_policy.new?     |


