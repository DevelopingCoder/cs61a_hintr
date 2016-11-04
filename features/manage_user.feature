Feature: Manage Users
  
  As hintr admin
  So that I can manage my users
  I want to be able to add users so they can signup
  And I want to be able to delete users
  And I want to be able to assign a user admin priveleges
  
  As a nonadmin
  I should not be able to do any of the above 
  
Background: An admin and a nonadmin account exist
  
  Given the following accounts exist:
  | name       | email                     | password          | admin |
  | testadmin  | testadmin@gmail.com       | password          | true  |
  | testuser2  | test2@gmail.com           | password          | false |
  | testuser3  | test3@gmail.com           | password          | false |
  | testadmin2 | testadmin2@gmail.com      | password          | true  |
  
  Given I log in with email: "testadmin@gmail.com" and password: "password"
  And I follow "Users"

Scenario: Admin should be able to add a new user email

  And I fill in "add_email" with "testuser1@gmail.com"
  And I fill in "add_name" with "testuser1"
  And I press "Add"
  Then I should see "Email invite has been sent"
  And I should see "testuser1@gmail.com"
  And I should see "testuser1"
  
@javascript
Scenario: Admin should be able to delete users
  Given I should see "test3@gmail.com"
  And I should see "test2@gmail.com"
  When I check "delete_test2@gmail.com"
  And I check "delete_test3@gmail.com"
  And I press "Delete Users"
  Then I should see "Are you sure you want to delete?"
  When I press "OK" within "ajs-footer"
  # Then I should see "Successfully deleted"
  # And I should not see "testuser2"
  # And I should not see "testuser3"

Scenario: Admins should not be able to delete other admins
  Then the delete checkbox for "testadmin@gmail.com" should be disabled
  Then the delete checkbox for "testadmin2@gmail.com" should be disabled

@javascript
Scenario: Admin should be able to assign a user admin privileges
  When I check the admin checkbox for "test2@gmail.com"
  # Then I should see "Are you sure you want to make testuser2 an admin?"
  # When I press "Confirm"
  Then I should see "testuser2 is now an admin"
  Then "test2@gmail.com" should be an admin

@javascript  
Scenario: Admin should be able to remove admin privileges
  When I uncheck the admin checkbox for "testadmin2@gmail.com"
  # Then I should see "Are you sure remove admin privileges for testadmin2?"
  # When I press "Confirm"
  Then I should see "testadmin2 is no longer an admin"
  Then "testadmin2@gmail.com" should not be an admin
  
Scenario: Users should not be able to add or delete user
  Given I logout
  And I log in with email: "test2@gmail.com" and password: "password"
  And I follow "Users"
  Then I should see all users
  But I should not see "Add"
  And I should not see "Delete Users"
