Feature: Uploading
  As a user, I can upload a file
  And I can see new data as a result of the upload 
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testuser   | testuser@gmail.com        | password          | false |
    
    Given I log in with email: "testuser@gmail.com" and password: "password"

  
Scenario: I can upload a concepts file
    Given I follow "Uploads"
    And I choose to upload a "Concepts" file
    Then I upload "concepts.csv"
    When I am on the home page
    And I follow "Concepts"
    Then I should see "test concept"
    When I follow "test concept"
    Then I should see "test tag 1"
    And I should see "test tag 2"
    And I should see "test_concept_description"