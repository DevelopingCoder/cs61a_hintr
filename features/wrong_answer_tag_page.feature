Feature: Wrong Answer Tag Page
  As a hintr user
  I want to be able to view Wrong Answer Tag information
  And I want to be able to create new hints for Tags
  
Background:
  Given I am logged in
  And the Question Set "qset1" exists
  And the Question Set "qset1" has the following questions:  
    | text                                           | case_string            |
    | what would python print? print 'hello world'   | question#1case#1       |
  And the following Wrong Answers exist:
    | wrong_answer_text | question                                     |
    | None              | what would python print? print 'hello world' |
    | Some              | what would python print? print 'hello world' |
  And the following Tags exist:
    | name      | description         | example    |
    | printing  | printing in python  | print 'hi' |
  And the following hints exist:
    | tag        | content                              | wrong_answer      |
    | printing   | print statements evaluate to None    | None              |
    | printing   | print takes in strings as arguments  | None              |
    | printing   | printing is not the same as return   | None              |
    | printing   | print-wrong-answer-2                 | Some              |
  
  And I follow "Question Sets"
  And I follow "qset"
  And I follow "printingNone"
  
Scenario: The Wrong Answer Tag Page shows Question Text, Wrong Answer Text, and Tag name
  Then I should see "what would python print? print 'hello world'"
  And I should see "qset1"
  And I should see "None"
  And I should see "printing"

Scenario: A user can upvote a hint
  Given I upvote the hint "print takes in strings as arguments"
  Then the hint "print takes in strings as arguments" should have 1 upvote
  And the hint "print takes in strings as arguments" should have 0 downvotes
  
Scenario: A user can downvote a hint
  Given I downvote the hint "print takes in strings as arguments"
  Then the hint "print takes in strings as arguments" should have 1 downvote
  And the hint "print takes in strings as arguments" should have 0 upvotes
  
Scenario: A user can toggle a downvote
  Given I downvote the hint "print takes in strings as arguments"
  Then the hint "print takes in strings as arguments" should have 1 downvote
  And the hint "print takes in strings as arguments" should have 0 upvotes
  When I downvote the hint "print takes in strings as arguments"
  Then the hint "print takes in strings as arguments" should have 0 downvotes
  And the hint "print takes in strings as arguments" should have 0 upvotes
   
Scenario: A user can toggle an upvote
  Given I upvote the hint "print takes in strings as arguments"
  Then the hint "print takes in strings as arguments" should have 0 downvote
  And the hint "print takes in strings as arguments" should have 1 upvotes
  When I upvote the hint "print takes in strings as arguments"
  Then the hint "print takes in strings as arguments" should have 0 downvotes
  And the hint "print takes in strings as arguments" should have 0 upvotes
  
Scenario: A user can change their vote from up to downvote 
  Given I downvote the hint "print takes in strings as arguments"
  And I upvote the hint "print takes in strings as arguments"
  Then the hint "print takes in strings as arguments" should have 1 upvote
  And the hint "print takes in strings as arguments" should have 0 downvotes

Scenario: A user can delete a hint
  Given I delete the hint "print statements evaluate to None"
  Then I should not see "print statements evaluate to None"

Scenario: A user can select to add other hints from same tag
  Then I should see "printing is not the same as return"
  And I select "print-wrong-answer-2"
  And I press "Post hint"
  Then I should see "print-wrong-answer-2"
  Given I upvote the hint "printing is not the same as return"
  Then the hint "printing is not the same as return" should have 1 upvote
  
Scenario: A user can sort their messages
  Given I downvote the hint "print takes in strings as arguments"
  And I upvote the hint "print statements evaluate to None"
  When I sort by "Downvotes"
  Then I should see "print takes in strings as arguments" before "print statements evaluate to None"
  When I sort by "Upvotes"
  Then I should see "print statements evaluate to None" before "print takes in strings as arguments" 
  