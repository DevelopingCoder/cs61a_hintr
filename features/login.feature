Feature: user login 
  
    As a 61a TA
    So that I can login to the hintr app
    I want to be able to login and see the dashboard
    
Background: user already has an account
  
  Given the following accounts exist:
    | email                     | password          | admin |
    | testuser@gmail.com        | password          | false |
  
Scenario: Not logged in user will get redirected to login page
  Given I visit the home page
  Then I should be on the login page
  And I fill in "email" with "testuser@gmail.com"
  And I fill in "password" with "password"
  And I click "login"
  Then I should be on the user dashboard for "testuser@gmail.com"
  
Scenario: Logged in user will get redirected to dashboard
  Given I log in with email: "testuser@gmail.com" and password: "password"
  And I visit the home page
  Then I should be on the dashboard
  
Scenario: Logging out should log the user out
  Given I log in with email: "testuser@gmail.com" and password: "password"
  And I am on the dashboard
  And I click "logout"
  Then I should be on the logout page

Scenario: User can see full user list
  Given I log in with email: "testuser@gmail.com" and password: "password"
  And I am on the dashboard
  And I click "users"
  Then I should see 1 user
  