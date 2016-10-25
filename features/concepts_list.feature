Feature: Concept viewing
  
  As hintr user
  So that I can interact with concepts
  I want to be able to view all concepts and their status
  And I want to be able to view tags and comments associated with concepts
  And I want to be able to vote on concept comments

Background: A hintr account and concepts exist
  
  Given the following accounts exist:
  | name       | email                     | password          | admin |
  | testuser   | testuser@gmail.com        | password          | false |
  And the following concepts exists:
  | name       | status       | tags                            |
  | printing   | assigned     | none, strings                   |
  | recursion  | in_progress  | tail recursion, tree recursion  |
  | loops      | no_comments  | iteration                       |
  And I log in with email: "testuser@gmail.com" and password: "password"

Scenario: User can view a list of concepts and their status 
  When I follow "Concepts"
  Then I should see all concepts