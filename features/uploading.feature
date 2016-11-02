Feature: Uploading
  As a user, I can upload a file
  And I can see new data as a result of the upload 
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true |
    
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads"

  
Scenario: I can upload a Concepts file
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"
    
    When I am on the concepts page
    Then I should see "test concept"
    And I should see "test concept 2"
    When I follow "test concept"
    Then I should see "test tag 1"
    And I should see "test tag 2"
    And I should see "test_concept_description"

Scenario: I can upload a Users file
    Given I choose to upload a "Users" file with "users.csv"
    Then I press "Upload"
    
    When I am on the users page
    Then I should see "example1@gmail.com"
    And I should see "Example Uno"
    And I should see "example2@gmail.com"
    And I should see "Example Dos"

Scenario: I can upload multiple files
    Given I choose to upload a "Concepts" file with "concepts.csv"
    Given I choose to upload a "Users" file with "users.csv"
    Then I press "Upload"
    
    When I am on the users page
    Then I should see "example1@gmail.com"
    And I should see "Example Uno"
    And I should see "example2@gmail.com"
    And I should see "Example Dos"
    
    When I am on the concepts page
    Then I should see "test concept"
    And I should see "test concept 2"
    When I follow "test concept"
    Then I should see "test tag 1"
    And I should see "test tag 2"
    And I should see "test_concept_description"