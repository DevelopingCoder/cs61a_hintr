Feature: Upload a tags2concepts file
  As a user, I can upload a tags2concepts csv file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true  |
    
    Given the following tag2concepts csv "tag2concepts.csv" exists:
    | Tag           | Concept           |
    | Bulbasaur     | test_concept 1    |
    | Squirtle      | test_concept 1    |
    | JigglyPuff    | test_concept 2    |
    | JigglyPuff    | test_concept 1    |
    
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads"

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