Feature: Wrong Answer Tag Page
  As a hintr user
  I want to be able to view Wrong Answer Tag information
  And I want to be able to create new hints for Tags
  
Background:
  Given I am logged in
  And the following Questions exist:
    | name                            | question_text               | case_string             |
    | what would python print?        | print "hello world"         | question#1case#1        |
  And the following Wrong Answers exist:
    | name            | wrong_answer_text | question            |
    | wrong answer 1  | None              | print "hello world" |
  And the following Tags exist:
    | name      | description           | 
    | printing  | "printing in python"  |
  And the following hints exist:
  | Tag        | content                              | wrong_answer      |
  | printing   | print statements evaluate to None    | wrong answer 1    |
  | printing   | print takes in strings as arguments  | wrong answer 1    |
  | printing   | printing is not the same as return   | wrong answer 2    |
  
  And I follow "Question Sets"
  And I follow "printing"
  
Scenario: The Wrong Answer Tag Page shows Question Text, Wrong Answer Text, and Tag description
  Then I should see "print \"hello world\""
  And I should see "None"
  And I should see "printing in python"

Scenario: A user can upvote a hint
  Given I upvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 upvote
   And "print takes in strings as arguments" should have 0 downvotes
  
Scenario: A user can downvote a hint
  Given I downvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 downvote
  And "print takes in strings as arguments" should have 0 upvotes
  
Scenario: A user cannot downvote on a hint twice
  Given I downvote "print takes in strings as arguments"
  And I downvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 downvote
  And "print takes in strings as arguments" should have 0 upvotes
  
Scenario: A user can change their vote from up to downvote 
  Given I downvote "print takes in strings as arguments"
  And I upvote "print takes in strings as arguments"
  Then "print takes in strings as arguments" should have 1 upvote
  And "print takes in strings as arguments" should have 0 downvotes

Scenario: A user can delete a hint
  Given I delete "print statements evaluate to None"
  Then I should not see "print statements evaluate to None"

Scenario: A user can select to add other hints from same tag
  Then I should see "printing is not the same as return"
  And I press "printing-wrong-answer-2"
  Given I upvote "printing is not the same as return"
  Then "printing is not the same as return" should have 1 upvote
  