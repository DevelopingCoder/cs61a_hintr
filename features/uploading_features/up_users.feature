Feature: Upload a Users file
  As a user, I can upload a users csv file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true  |
    
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads"
    
Scenario: I can upload a Users file
    Given I choose to upload a "Users" file with "users.csv"
    Then I press "Upload"
    Then I should be on the upload page
    When I am on the users page
    Then I should see "example1@gmail.com"
    And I should see "Example Uno"
    And I should see "example2@gmail.com"
    And I should see "Example Dos"