Feature: Finalize messages
  
  As a hintr user
  I want to be able to set a message for a concept
  
Background: A user and concepts exist
  Given the following concepts exist:
  | name       | msg_status       | description         |
  | printing   | assigned         | print method        |
  And the following messages exist:
  | concept    | content                              |
  | printing   | print statements evaluate to None    |
  | printing   | print takes in strings as arguments  |
  And I am logged in
  And I follow "Concepts"
  And the threshold is 1
  And I follow "printing"
  
Scenario: The concept page shows the finalized checkbox correctly
  Given I upvote "print statements evaluate to None"
  Then I should be able to finalize "print statements evaluate to None"
  And I should not be able to finalize "print takes in strings as arguments"
  
Scenario: A user is able to finalize a message 
  Given I upvote "print statements evaluate to None"
  And I finalize "print statements evaluate to None"
  Then "print statements evaluate to None" should be finalized
  
Scenario: A user is able to change assigned messages for a concept
  Given "print statements evaluate to None" is finalized
  And I upvote "print takes in strings as arguments"
  And I finalize "print takes in strings as arguments"
  Then "print statements evaluate to None" should not be finalized
  And "print takes in strings as arguments" should be finalized

Scenario: A user is able to unfinalize a message
  And I upvote "print statements evaluate to None"
  And I finalize "print statements evaluate to None"
  And I unfinalize "print statements evaluate to None"
  Then "print statements evaluate to None" should not be finalized