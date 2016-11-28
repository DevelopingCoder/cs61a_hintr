Feature: Upload a Tags file
  As a user, I can upload a tags csv file
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
    | tag_deletion| dontmatter              | example   |
    
    Given the following "tags.csv" exists:
    |Old tag name|cp|Status|Tag Name|Description|Example|Primary Concept|Topic|Count in Tag to Concept Master|Concepts|
    ||||test_tag_1|test_description_1|example||topic_1|||
    ||||test_tag_2|new_test_description_2|example_2|||||
    ||||test_tag_3|test_description_3|new_example_3|||||
    ||||test_tag_4|new_test_description_4|new_example_4|||||
    ||||test_tag_addition|description|example addition|||||

    Given the following "failed_tags.csv" exists:
    |Old tag name|cp|Status|Tag Name|Description|Example|Primary Concept|Topic|Count in Tag to Concept Master|Concepts|
    ||||test_tag_1|test_description_1|example||topic_1|||
    ||||test_tag_2|new_test_description_2|example_2|||||
    |||||test_description_3|new_example_3|||||
    ||||test_tag_4|new_test_description_4|new_example_4|||||
    ||||test_tag_addition|description|example addition|||||
    
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads"

Scenario: I can upload a tags file and confirm all actions
    Given I select "Tags (csv)"
    Given I choose to upload a file with "tags.csv"
    And I press "Upload"
  
    And I should see id "edit_test_tag_2" 
    And I should see id "edit_test_tag_3"
    And I should see id "edit_test_tag_4" 
    And I should see id "delete_tag_deletion"
    And I should see id "add_test_tag_addition"
  
    When I check "delete_tag_deletion"
    And I check "add_test_tag_addition"
    When I press "Confirm Upload"
    Then I should see "Success"
    
Scenario: Uploading an invalid file will give an error
    Given I select "Tags (csv)"
    And I choose to upload a file with "failed_tags.csv"
    And I press "Upload"
    
    Then I should see "Tag name doesn't exist for one of 'em. Upload aborted"
    
Scenario: I lose my state when I refresh the page
    Given I select "Tags (csv)"
    Then I choose to upload a file with "tags.csv"
    And I press "Upload"
    When I refresh the page
    Then I should not see "test_concept_9"
    And I should see "Oops we lost your state. Please upload again"
    
Scenario: I should not be able to upload an incorrectly formatted file 
    Given I select "Tags (csv)"
    Given I choose to upload a file with "users.csv"
    And I press "Upload"
    Then I should see "Tag file not correctly formatted." 