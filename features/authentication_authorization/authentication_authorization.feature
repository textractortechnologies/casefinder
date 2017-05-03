Feature: Authenticating and authorizing access
  User should be able to access authorized resources if authenticated

  Background: Everything is setup
    Given abstraction schemas are setup
    And roles are setup

  @javascript
  Scenario: Visiting pages authenticated and authorized as an admin
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    And "example.user@test.com" is authorized as an admin
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    Then the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    When I visit the pathology cases index page
    Then I should be on the pathology cases index page
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    When I visit the review page for accession number "123"
    And I wait 1 seconds
    Then I should be on the edit page of accession number "123"
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:edit with params: {"id"=>"1"}     |
    When I visit the new export page
    Then I should be on the new export page
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:edit with params: {"id"=>"1"}     |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | batch_exports:new                                 |
    When I visit the abstactor abstraction schemas page
    Then I should be on the abstractor abstraction schemas page
    When I visit the index page for the "has_cancer_histology" abstractor abstraction schema
    Then I should be on the index page for the "has_cancer_histology" abstractor abstraction schema
    When I visit the new abstractor object value page for the "has_cancer_histology" abstractor abstraction schema
    Then I should be on the new abstractor object value page for the "has_cancer_histology" abstractor abstraction schema
    When I visit the index page for the "has_cancer_histology" abstractor abstraction schema
    When I visit the edit page for the first abstractor object value
    Then I should be on the edit abstractor object value page for the "has_cancer_histology" abstractor abstraction schema

  @javascript
  Scenario: Visiting pages authenticated and authorized
    Given pathology cases with the following information exist
      | Accession Number | Collection Date  | Note                                                                                                        |
      | 123              | 01/01/2015         | Looks like carcinoma of of the external lip to me.  But maybe large cell carcinoma of the base of tongue.   |
      | 124              | 02/01/2015         | Base of tounge looks all good to me.                                                                        |
      | 125              | 03/01/2015         | Pleomorphic carcinoma of the lower gum is the likley culprit.                                               |
    And "example.user@test.com" is authorized as a user
    When "example.user@test.com" logs in with password "secret"
    And I wait 1 seconds
    Then the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    When I visit the pathology cases index page
    Then I should be on the pathology cases index page
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    When I visit the review page for accession number "123"
    And I wait 1 seconds
    Then I should be on the edit page of accession number "123"
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:edit with params: {"id"=>"1"}     |
    When I visit the new export page
    Then I should be on the new export page
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | pathology_cases:edit with params: {"id"=>"1"}     |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | batch_exports:new                                 |
    When I visit the abstactor abstraction schemas page
    Then I should be informed that I am unauthorized
    When I visit the index page for the "has_cancer_histology" abstractor abstraction schema
    Then I should be informed that I am unauthorized
    When I visit the new abstractor object value page for the "has_cancer_histology" abstractor abstraction schema
    Then I should be informed that I am unauthorized

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
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new with params: {"commit"=>"Log in"}    |
    | example.user@test.com | VALUE: AccessAudit.login_failure            |                                                   |
    And I should see "Invalid username or password." within "#alert"
    When I visit the pathology cases index page
    Then I should be on the sign in page
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new with params: {"commit"=>"Log in"}    |
    | example.user@test.com | VALUE: AccessAudit.login_failure            |                                                   |
    | unknown               | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    And I should see "You need to sign in or sign up before continuing." within "#alert"
    When I visit the new import page
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing." within "#alert"
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new with params: {"commit"=>"Log in"}    |
    | example.user@test.com | VALUE: AccessAudit.login_failure            |                                                   |
    | unknown               | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | unknown               | VALUE: AccessAudit.controller_action_access | batch_imports:new                                 |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    When I visit the new export page
    Then I should be on the sign in page
    And I should see "You need to sign in or sign up before continuing." within "#alert"
    And the "AccessAudit" records should match
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new with params: {"commit"=>"Log in"}    |
    | example.user@test.com | VALUE: AccessAudit.login_failure            |                                                   |
    | unknown               | VALUE: AccessAudit.controller_action_access | pathology_cases:index                             |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | unknown               | VALUE: AccessAudit.controller_action_access | batch_imports:new                                 |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | unknown               | VALUE: AccessAudit.controller_action_access | batch_exports:new                                 |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |

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
    | username              | action                                      | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success            |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access | curate:index                                      |
    When I visit the pathology cases index page
    And I wait 1 seconds
    Then I should be on the home page
    And I should see "You are not authorized to perform this action." within "#alert"
    And the "AccessAudit" records should match
    | username              | action                                          | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access     | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success                |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | pathology_cases:index                             |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt  | pathology_case_policy.index?                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
    When I visit the new import page
    Then I should be on the home page
    And I should see "You are not authorized to perform this action." within "#alert"
    And the "AccessAudit" records should match
    | username              | action                                          | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access     | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success                |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | pathology_cases:index                             |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt  | pathology_case_policy.index?                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | batch_imports:new                                 |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt  | batch_import_policy.new?                          |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
    When I visit the new export page
    Then I should be on the home page
    And I should see "You are not authorized to perform this action." within "#alert"
    And the "AccessAudit" records should match
    | username              | action                                          | description                                       |
    | unknown               | VALUE: AccessAudit.controller_action_access     | sessions:new                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | sessions:create with params: {"commit"=>"Log in"} |
    | example.user@test.com | VALUE: AccessAudit.login_success                |                                                   |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | pathology_cases:index                             |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt  | pathology_case_policy.index?                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | batch_imports:new                                 |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt  | batch_import_policy.new?                          |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | batch_exports:new                                 |
    | example.user@test.com | VALUE: AccessAudit.unauthorized_access_attempt  | batch_export_policy.new?                          |
    | example.user@test.com | VALUE: AccessAudit.controller_action_access     | curate:index                                      |
