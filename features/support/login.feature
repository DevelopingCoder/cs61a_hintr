Feature: user login 
  
    As a 61a TA
    So that I can login to the hintr app
    I want to be able to login and see the dashboard
    
Background: user already has an account
  
  Given the following accounts exist:
    | email                     | password          |
    | testuser@gmail.com        | password          |
  
Scenario: user is not logged in
  Given I visit the dashboard
  Then I should see the login page
  And I fill in the email field with "testuser@gmail.com"
  And I fill in the password with "password"
  And I click "login"
  Then I should see the user dashboard
  
Scenario: user is logged in
  Given I visit the home page
  Then I should see the user dashboard
  And I should not see the login page
  
Scenario: user is logged in and on dashboard
  Given I am on the dashboard
  And I click "logout"
  Then I should see the logout page