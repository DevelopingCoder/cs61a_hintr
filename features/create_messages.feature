Feature: message creation 
  
  As a hintr user
  So that I can create messages on concepts
  I want to be able to draft and submit a message for a given concepts
  
Background: A user and concept exists
  
  Given I am logged in
  And the following concepts exist:
  | name       | status          | tags                            |
  | printing   | no messages     | none, strings                   |
  And I follow "concepts"
  And I follow "printing"
 
Scenario: Create a valid message 
  Given I press "new message"
  And I fill in "message input" with "print statements evaluate to None"
  And I press "submit"
  Then I should see "print statements evaluate to None"
  
Scenario: Create an invalid message
  Given I press "new message"
  And I press "submit"
  Then I should see "message must have body"