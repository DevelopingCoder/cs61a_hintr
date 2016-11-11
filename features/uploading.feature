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

Scenario: I can upload a Concepts file and confirm all actions
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"

    And I should see "Add the concept 'test_concept 2'"
    And I should see "Delete the concept 'test_concept 4'"
    And I should see "Edit the concept 'test_concept 3"
    Then I should not see "test_concept 1"
    
    When I confirm the change for concept "test_concept 4"
    And I confirm the change for concept "test_concept 3"
    Then I press "Confirm Update"

    When I am on the concepts page
    Then I should see "test_concept 1"
    And I should see "test_concept 2"
    And I should see "test_concept 3"
    And I should not see "test_concept 4"
    When I follow "test_concept 3"
    And I should see "new_test_concept_description3"
    
Scenario: I can upload a Concepts file and don't confirm all actions
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"

    And I should see "Add the concept 'test_concept 2'"
    And I should see "Delete the concept 'test_concept 4'"
    And I should see "Change the description of 'test_concept 3"
    Then I should not see "test_concept 1"
    Then I press "Confirm Update"

    When I am on the concepts page
    Then I should see "test_concept 1"
    And I should see "test_concept 2"
    And I should see "test_concept 3"
    And I should see "test_concept 4"
    When I follow "test_concept 3"
    And I should see "test_concept_description3"
  
Scenario: Not pressing confirm when uploading Concepts doesn't make changes
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"
    Then I should be on the upload confirmation page
    
    When I am on the concepts page
    Then I should not see "test_concept 2"
    
Scenario: Pressing cancel when uploading Concepts doesn't make changes
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"
    Then I should be on the upload confirmation page
    When I press "Cancel"
    Then I should be on the upload page
  
    When I am on the concepts page
    Then I should not see "test_concept 2"

Scenario: I can upload a Users file
    Given I choose to upload a "Users" file with "users.csv"
    Then I press "Upload"
    Then I should be on the upload page
    When I am on the users page
    Then I should see "example1@gmail.com"
    And I should see "Example Uno"
    And I should see "example2@gmail.com"
    And I should see "Example Dos"

Scenario: I can upload a tag2concepts file
    Given I choose to upload a "Tags2Concepts" file with "tags2concepts.csv"
    When I press "Upload"
    Then I should be on the upload confirmation page
    And I should see "Tag:'JigglyPuff'? to Connect Concept: 'test_concept 1'"
    And I should see "Tag:'JigglyPuff'? to Connect Concept: 'test_concept 2'"
    And I should see "Tag:'Squirtle' to Disconnect Concept: 'test_concept 2'"
    And I should see "Tag: Pikachu does not exist"
    And I should see "Concept: Hitman does not exist"
    
    When I confirm the change for concept "Squirtle" and tag "test_concept 2"
    And I press "Confirm Upload"
    Then I should see "Success"


Scenario: Uploading a file that adds new tags should ask for confirmation
    Given I choose to upload a "Tags" file with "tags.csv"
    And I press "Upload"
  
    Then I should see "Add the tag 'JigglyPuff?'"
    Then I should see "Add the tag 'Squirtle?'"
    Then I should see "Delete the tag 'Charmander?'" 
  
    When I press confirm for tag "Charmander"
    And I press "Confirm Upload"
    Then I should see "Success"

Scenario: Uploading a question file successfully should be successfully
    Given I choose to upload a "Question" file with "questionData.json"
    And I press "Upload"
    And I press "Confirm Upload"
    Then I should see "Success"
  
# Scenario: Uploading a question file that has an unknown tag should raise an error
#     Given I choose to upload a "Question" file with "questionDataSadPath.json"
#     And I press "Upload"
#     Then I should see "'Water Types' is an unknown tag. Please upload new tags file. Aborting upload"
  
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
