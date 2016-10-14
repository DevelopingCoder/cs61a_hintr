Feature: user creation
  
  As hintr admin
  So that I can manage my users
  I want to be able to add users so they can signup
  And I want to be able to delete users
  
Background: I am a hintr admin
  
  Given the following accounts exist
    | email                     | password          | admin |
    | testadmin@gmail.com       | password          | 1     |
    | testuser@gmail.com        | password          | 0     |
  
  And I am logged in
  And I visit the dashboard
  
Scenario: Admin should be able to add a new user email
  Given I click "users"
  Then I should see all users
  And I fill in "Add New User" with "testuser@gmail.com"
  And I click "Add"
  Then I should see "Email invite(s) have been sent"
  
Scenario: Admin should be able to delete users
  Given I click "users"
  Then I should see all users
  And I click on "delete" for "testuser@gmail.com"
  Then I should not see "testuser@gmail.com"
  