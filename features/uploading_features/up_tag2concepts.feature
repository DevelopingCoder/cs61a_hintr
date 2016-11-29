# Feature: Upload a tags2concepts file
#   As a user, I can upload a tags2concepts csv file
#   And I can see new data as a result of the upload
  
# Background: A user account exists

#     Given the following accounts exist:
#     | name       | email                     | password          | admin |
#     | testadmin  | testadmin@gmail.com       | password          | true  |
    
#     Given the following tag2concepts csv "tag2concepts.csv" exists:
#     | Tag           | Concept           |
#     | Bulbasaur     | test_concept 1    |
#     | Squirtle      | test_concept 1    |
#     | JigglyPuff    | test_concept 2    |
#     | JigglyPuff    | test_concept 1    |
    
#     Given I log in with email: "testadmin@gmail.com" and password: "password"
#     And I follow "Uploads"

# Scenario: I can upload a tag2concepts file
#     Given I choose to upload a "Tags2Concepts" file with "tags2concepts.csv"
#     When I press "Upload"
#     Then I should be on the upload confirmation page
#     And I should see "Tag:'JigglyPuff'? to Connect Concept: 'test_concept 1'"
#     And I should see "Tag:'JigglyPuff'? to Connect Concept: 'test_concept 2'"
#     And I should see "Tag:'Squirtle' to Disconnect Concept: 'test_concept 2'"
#     And I should see "Tag: Pikachu does not exist"
#     And I should see "Concept: Hitman does not exist"
    
#     When I confirm the change for concept "Squirtle" and tag "test_concept 2"
#     And I press "Confirm Upload"
#     Then I should see "Success"

Feature: Upload a Tags file
  As a user, I can upload a tag2concepts csv file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true  |
    
    Given the following tags exist:
    | name        | description             | example   |
    | test_tag_1  | test_description_1      | example   |
    | test_tag_2  | test_description_2      | example_2 |
    | test_tag_3  | test_description_3      | example_3 |
    | test_tag_4  | new_test_description_4  | example_4 |
    
    Given the following concepts exist:
    | name           | description               |
    | test_concept_1 | test_concept_description1 |
    | test_concept_2 | test_concept_description2 |
    | test_concept_3 | test_concept_description3 |
    | test_concept_4 | test_concept_description4 |

    Given the following "tag2concepts.csv" exists:
    | Tag        | Concept        |
    | test_tag_1 | test_concept_1 |
    | test_tag_3 | test_concept_1 |
    | test_tag_1 | test_concept_3 |
     
    Given the following "failed_tag2concepts.csv" exists:
    | Tag        | Concept        |
    | test_tag_1 | test_concept_1 |
    | test_tag_3 | wtf1           |
    | test_tag_1 | test_concept_3 |
    
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads"

Scenario: I can upload a tag2concepts file and confirm all actions
    Given I select "Tag2concepts (csv)"
    Given I choose to upload a file with "tag2concepts.csv"
    And I press "Upload"
    Then I should see id "add_tag-test_tag_1_concept-test_concept_1" 
    When I uncheck "add_tag-test_tag_1_concept-test_concept_3"
    And I press "Confirm Upload"
    Then I should see "Success"
    
    When I am on the concepts page
    And I follow "test_concept_1"
    Then I should see "test_tag_1"
    
Scenario: Uploading an invalid file will give an error
    Given I select "Tag2concepts (csv)"
    And I choose to upload a file with "failed_tag2concepts.csv"
    And I press "Upload"
    Then I should see "One of the concepts doesn't exist. Upload aborted"
    
Scenario: I lose my state when I refresh the page
    Given I select "Tag2concepts (csv)"
    Then I choose to upload a file with "tag2concepts.csv"
    And I press "Upload"
    When I refresh the page
    And I should see "Oops we lost your state. Please upload again"
    
Scenario: I should not be able to upload an incorrectly formatted file 
    Given I select "Tag2concepts (csv)"
    Given I choose to upload a file with "users.csv"
    And I press "Upload"
    Then I should see "Tag2concept file not correctly formatted" 