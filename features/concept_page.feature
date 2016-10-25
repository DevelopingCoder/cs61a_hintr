Feature: Concept page
  
  As a hintr user 
  So that I can see information on a concept
  I want to be able to view comments and tags for a concept
  And I want to be able to vote on comments
  
Background: A user and concept exists
  Given the following concepts exist:
  | name       | status          | tags                            |
  | printing   | no comments     | none, strings                   |
  And the following comments exist:
  | concept    | body                                 |
  | printing   | print statements evaluate to None    | 
  | printing   | print takes in strings as arguments  |
  And I am logged in 
  And I follow "concepts"
  
Scenario: The concept page shows associated comments and tags 
  Given I follow "printing"
  Then I should see "print statements evaluate to none"
  And I should see "print takes in strings as arguments"
  And I should see "none"
  And I should see "strings"
  
Scenario: A user can upvote a comment
  Given I follow "printing"
  And I upvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 upvote
  
Scenario: A user can downvote a comment
  Given I follow "printing"
  And I downvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 downvote

Scenario: A user can delete a comment
  Given I follow "printing"
  And I delete "print statements evaluate to None"
  Then I should not see "print statements evaluate to None"
