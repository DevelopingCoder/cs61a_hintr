Feature: Uploading
  As a user, I can upload a file
  And I can see new data as a result of the upload 
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true  |
    
    Given the following tags exist:
    | name        | description |
    | Bulbasaur   | bulba!      |
    | Charmander  | char!       |
    
    Given the following concepts exist:
    | name           | msg_status       | description               |
    | test_concept 1 | in progress      | test_concept_description  |
    | test_concept 3 | in progress      | test_concept_description3 |
    | test_concept 4 | in progress      | test_concept_description4 |

    Given the following tag to concept relations exist:
    | tag       | concept          |
    | Bulbasaur | test_concept 1   |
    | Squirtle  | test_concept 2   |
    | Squirtle  | test_concept 1   |
    
    Given the following concepts csv "concepts.csv" exists:
    | Concept        | Description                   | Message                |
    | test_concept 1 | test_concept_description      | concept msg_example_1  |
    | test_concept 2 | new_test_concept_description3 |                        |
    | test_concept 3 | new_test_concept_description3 |                        |
    
    Given the following tags csv "tags.csv" exists:
    | Tag Name      | Description |
    | Bulbasaur     | bulba!      |
    | JigglyPuff    | jiggly!     |
    | Squirtle      | squirt!     |
    
    Given the following tag2concepts csv "tag2concepts.csv" exists:
    | Tag           | Concept           |
    | Bulbasaur     | test_concept 1    |
    | Squirtle      | test_concept 1    |
    | JigglyPuff    | test_concept 2    |
    | JigglyPuff    | test_concept 1    |
    
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads"

Scenario: I can upload multiple files
    Given I choose to upload a "Concepts" file with "concepts.csv"
    Given I choose to upload a "Tags" file with "tags.csv"
    Given I choose to upload a "Users" file with "users.csv"
    Then I press "Upload"
    Then I should be on the upload confirmation page
    
    And I should see "Add the concept 'test_concept 2'"
    And I should see "Delete the concept 'test_concept 4'"
    And I should see "Change the description of 'test_concept 3"
    Then I should not see "test_concept 1"
    
    Then I should see "Add the tag 'JigglyPuff?'"
    Then I should see "Add the tag 'Squirtle?'"
    Then I should see "Delete the tag 'Charmander?'" 
    
Scenario: I should not be able to upload an incorrectly formatted file 
  Given I choose to upload a "Concepts" file with "tags.csv"
  And I press "Upload"
  Then I should see "Concepts file not correctly formatted.  Aborting upload."
