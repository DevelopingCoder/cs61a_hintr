Feature: Upload a Users file
  As a user, I can upload a users csv file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true  |
    
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads"
    
    Given the following "bad.csv" exists:
    | Concept        |
    | test_concept_1 |
    
Scenario: I can upload a Users file
    Given I select "Users (csv)"
    Given I choose to upload a file with "users.csv"
    Then I press "Upload"
    Then I should be on the upload page
    When I am on the users page
    Then I should see "example1@gmail.com"
    And I should see "Example Uno"
    And I should see "example2@gmail.com"
    And I should see "Example Dos"

Scenario: I should not be able to upload an incorrectly formatted file 
    Given I select "Users (csv)"
    Given I choose to upload a file with "concepts.csv"
    And I press "Upload"
    Then I should see "Users file not correctly formatted. First 2 columns must be Name, Email"
    
Scenario: I should not be able to upload an incorrectly formatted file 
    Given I select "Users (csv)"
    Given I choose to upload a file with "bad.csv"
    And I press "Upload"
    Then I should see "Users file not correctly formatted. First 2 columns must be Name, Email"

Scenario: Uploading nothing will give me an error message
    Given I select "Users (csv)"
    And I press "Upload"
    Then I should see "Please attach a file"