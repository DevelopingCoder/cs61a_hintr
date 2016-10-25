Feature: Uploading
  As a user, I can upload a file
  And I can see new data as a result of the upload 
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
<<<<<<< bb18468162551b3dcb332105213c33f504d32753
    | testadmin  | testadmin@gmail.com       | password          | false |
    
    Given I log in with email: "testuser@gmail.com" and password: "password"
    And I follow "Uploads"

  
Scenario: I can upload a Concepts file
    Given I press "choose_concepts"
    And I choose "concepts.csv"
    When I press "Upload"
    Then I should see "Successfully uploaded concepts.csv"
    
    When I am on the concepts page
    Then I should see "test concept"
    And I should see "test concept 2"
    When I follow "test concept"
    Then I should see "test tag 1"
    And I should see "test tag 2"
    And I should see "test_concept_description"

Scenario: I can upload a Users file
    Given I press "choose_users"
    And I choose "users.csv"
    Then I press "Upload"
    Then I should see "Successfully uploaded users.csv"
    
    When I am on the users page
    Then I should see "example1@gmail.com"
    And I should see "Example Uno"
    And I should see "example2@gmail.com"
    And I should see "Example Dos"

Scenario: I can upload multiple files
    Given I press "choose_concepts"
    And I choose "concepts.csv"
    Given I press "choose_users"
    And I choose "users.csv"
    Then I press "Upload"
    Then I should see "Successfully uploaded concepts.csv, users.csv"
    
    When I am on the users page
    Then I should see "example1@gmail.com"
    And I should see "Example Uno"
    And I should see "example2@gmail.com"
    And I should see "Example Dos"
    
    When I am on the concepts page
    Then I should see "test concept"
    And I should see "test concept 2"
=======
    | testuser   | testuser@gmail.com        | password          | false |
    
    Given I log in with email: "testuser@gmail.com" and password: "password"

  
Scenario: I can upload a concepts file
    Given I follow "Uploads"
    And I choose to upload a "Concepts" file
    Then I upload "concepts.csv"
    When I am on the home page
    And I follow "Concepts"
    Then I should see "test concept"
>>>>>>> Created Cuke tests for Uploading
    When I follow "test concept"
    Then I should see "test tag 1"
    And I should see "test tag 2"
    And I should see "test_concept_description"