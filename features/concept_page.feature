Feature: Concept page
  
  As a hintr user 
  So that I can see information on a concept
  I want to be able to view messages and tags for a concept
  And I want to be able to vote on messages
  
Background: A user and concept exists
  Given the following concepts exist:
  | name       | msg_status       | description         |
  | printing   | assigned         | print method        |
  # add tags back when implemented
  # | name       | status          | tags                            |
  # | printing   | no messages     | none, strings                   |
  And the following messages exist:
  | concept    | content                              |
  | printing   | print statements evaluate to None    |
  | printing   | print takes in strings as arguments  |
  And I am logged in
  And I follow "Concepts"
  And I follow "printing"
  
Scenario: The concept page shows associated messages and tags 
  Then I should see "print statements evaluate to None"
  And I should see "print takes in strings as arguments"
  And "print takes in strings as arguments" should have 0 downvote
  And "print takes in strings as arguments" should have 0 upvote
  # check that you can see tags: 
  # And I should see "none"
  # And I should see "strings"
  
Scenario: A user can upvote a message
  Given I upvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 upvote
   And "print takes in strings as arguments" should have 0 downvotes
  
Scenario: A user can downvote a message
  Given I downvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 downvote
  And "print takes in strings as arguments" should have 0 upvotes
  
Scenario: A user can toggle a downvote
  Given I downvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 downvote
  And "print takes in strings as arguments" should have 0 upvotes
  When I downvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 0 downvotes
  And "print takes in strings as arguments" should have 0 upvotes
   
Scenario: A user can toggle an upvote
  Given I upvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 0 downvote
  And "print takes in strings as arguments" should have 1 upvotes
  When I upvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 0 downvotes
   And "print takes in strings as arguments" should have 0 upvotes
  
  
Scenario: A user can change their vote from up to downvote 
  Given I downvote "print takes in strings as arguments"
  And I upvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 upvote
  And "print takes in strings as arguments" should have 0 downvotes
  
Scenario: A user can sort their messages
  Given I downvote "print takes in strings as arguments"
  And I upvote "print statements evaluate to None"
  When I sort by "Downvotes"
  Then I should see "print takes in strings as arguments" before "print statements evaluate to None"
  When I sort by "Upvotes"
  Then I should see "print statements evaluate to None" before "print takes in strings as arguments" 
  

Scenario: A user can delete a message
  Given I delete "print statements evaluate to None"
  Then I should not see "print statements evaluate to None"