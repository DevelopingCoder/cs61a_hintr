Feature: user login 
  
    As a 61a TA
    So that I can login to the hintr app
    I want to be able to login and see the dashboard
    
Background: user already has an account
  
  Given the following accounts exist:
    | email                     | password          | admin |
    | testuser@gmail.com        | password          | 0     |
  
Scenario: Not logged in user will get redirected to login page
  Given I am not logged in
  Given I visit the home page
  Then I should be on the login page
  And I fill in "email" with "testuser@gmail.com"
  And I fill in "password" with "password"
  And I click "login"
  Then I should be on the user dashboard for "testuser@gmail.com"
  
Scenario: Logged in user will get redirected to dashboard
  Given I am logged in
  And I visit the home page
  Then I should be on the dashboard
  And I should not be on the login page
  
Scenario: Logging out should log the user out
  Given I am logged in
  And I am on the dashboard
  And I click "logout"
  Then I should be on the logout page

Scenario: User can see full user list
  Given I am logged in
  And I am on the dashboard
  And I click "users"
  Then I should see all users
  