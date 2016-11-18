Feature: Upload a Concepts file
  As a user, I can upload a concepts csv file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true  |

    Given the following concepts exist:
    | name           | description               |
    | test_concept_1 | test_concept_description1 |
    | test_concept_2 | test_concept_description2 |
    | test_concept_3 | test_concept_description3 |
    | test_concept_4 | test_concept_description4 |
    
    Given the following "concepts.csv" exists:
    | Concept        | Description                   | Message                |
    | test_concept_1 | new_test_concept_description1 | concept msg_example 1  |
    | test_concept_2 | new_test_concept_description2 |                        |
    | test_concept_9 | new_test_concept_description9 | concept msg_example 9  |
    | test_concept_4 | test_concept_description4     |                        |
    
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads"
    
Scenario: I can upload a Concepts file and confirm all actions
    Given I select "Concepts (csv)"
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"

    And I should see id "add_test_concept_9" 
    And I should see id "delete_test_concept_3"
    And I should see id "edit_test_concept_2"
    And I should see id "edit_test_concept_1"

    When I check "add_test_concept_9"
    And I check "delete_test_concept_3"
    And I check "edit_test_concept_2"
    And I check "edit_test_concept_1"
    When I press "Confirm Upload"
    Then I should see "Success"

    When I am on the concepts page
    Then I should see "test_concept_1"
    And I should see "test_concept_2"
    And I should not see "test_concept_3"
    And I should see "test_concept_4"
    And I should see "test_concept_9"
    When I follow "test_concept_1"
    And I should see "new_test_concept_description1"
    And I should see "concept msg_example 1"
    
Scenario: I can upload a Concepts file and don't confirm all actions
    Given I select "Concepts (csv)"
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"
    Then I press "Confirm Upload"

    When I am on the concepts page
    And I should see "test_concept_3"
    And I should not see "test_concept_9"
    When I follow "test_concept_1"
    Then I should not see "concept msg_example_1"
    
Scenario: Not pressing confirm when uploading Concepts doesn't make changes
    Given I select "Concepts (csv)"
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"

    When I am on the concepts page
    Then I should not see "test_concept_9"
    
Scenario: Pressing cancel when uploading Concepts doesn't make changes
    Given I select "Concepts (csv)"
    Given I choose to upload a "Concepts" file with "concepts.csv"
    When I press "Upload"
    When I follow "Cancel"
    Then I should be on the upload page
  
    When I am on the concepts page
    Then I should not see "test_concept_9"