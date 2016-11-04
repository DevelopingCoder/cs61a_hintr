Feature: user login 
  
    As a 61a TA
    So that I can login to the hintr app
    I want to be able to login and see the dashboard
    
Background: user already has an account
  
  Given the following accounts exist:
  | name       | email                     | password          | admin |
  | testadmin  | testadmin@gmail.com       | password          | true  |
  | testuser   | testuser@gmail.com        | password          | false |
  
Scenario: Not logged in user will get redirected to login page
  When I go to the home page
  Then I am on the login page
  And I fill in "user_email" with "testuser@gmail.com"
  And I fill in "user_password" with "password"
  And I press "Login"
  Then I should see "Signed in successfully"
  
Scenario: Logged in user will get redirected to dashboard
  Given I log in with email: "testuser@gmail.com" and password: "password"
  And I go to the home page
  Then I should see "Hello testuser"
  
Scenario: Logging out should log the user out
  Given I log in with email: "testuser@gmail.com" and password: "password"
  And I logout
  Then I should see "Signed out successfully"