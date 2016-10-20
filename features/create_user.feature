Feature: user creation
  
  As hintr admin
  So that I can manage my users
  I want to be able to add users so they can signup
  And I want to be able to delete users
  
  And as a nonadmin
  I should not be able to add users
  And I should not be able to delete users
  
Background: An admin and a nonadmin account exist
  
  Given the following accounts exist:
  | name       | email                     | password          | admin |
  | testadmin  | testadmin@gmail.com       | password          | true  |
  | testuser   | testuser@gmail.com        | password          | false |
  
  
Scenario: Admin should be able to add a new user email
  Given I log in with email: "testadmin@gmail.com" and password: "password"
  And I follow "Users"
  Then I should see all users
  And I fill in "add_email" with "testuser1@gmail.com"
  And I press "Add"
  Then I should see "Email invite(s) have been sent"
Scenario: Admin should be able to delete users
  Given I log in with email: "testadmin@gmail.com" and password: "password"
  And I follow "Users"
  And I fill in "delete_email" with "testuser@gmail.com"
  And I press "Delete"
  Then I should not see "testuser@gmail.com"
  
Scenario: Nonadmins should not be able to add or delete user
  Given I log in with email: "testuser@gmail.com" and password: "password"
  And I follow "Users"
  Then I should see all users
  But I should not see "Add"
  And I should not see "Add New User"
  And I should not see "delete testuser@gmail.com"