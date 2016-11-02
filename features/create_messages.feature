Feature: message creation 
  
  As a hintr user
  So that I can create messages on concepts
  I want to be able to draft and submit a message for a given concepts
  
Background: A user and concept exists
  
  Given I am logged in
  And the following concepts exist:
  | name       | msg_status       | description         |
  | printing   | assigned         | print method        |
  # | name       | status          | tags                            |
  # | printing   | no messages     | none, strings                   |
  And I follow "Concepts"
  And I follow "printing"
 
Scenario: Create a valid message 
  Given I fill in "add_message" with "print statements evaluate to None"
  And I press "Post Message"
  Then I should see "print statements evaluate to None"
  
Scenario: Create an invalid message
  And I press "Post Message"
  Then I should see "message must have body"