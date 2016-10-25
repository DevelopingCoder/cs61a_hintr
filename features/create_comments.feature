Feature: Comment creation 
  
  As a hintr user
  So that I can create comments on concepts
  I want to be able to draft and submit a comment for a given concepts
  
Background: A user and concept exists
  
  Given I am logged in
  And the concept "printing" exists with status "no comments" and tags "none, strings"
  And I follow "concepts"
  And I follow "printing"
 
Scenario: Create a valid comment 
  Given I press "new comment"
  And I fill in "comment input" with "print statements evaluate to None"
  And I press "submit"
  Then I should see "print statements evaluate to None"
  
Scenario: Create an invalid comment
  Given I press "new comment"
  And I press "submit"
  Then I should see "comment must have body" # or some similar error message