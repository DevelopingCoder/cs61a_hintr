Feature: Finalize hints
  
  As a hintr user
  I want to be able to set a hint for a tag2wronganswer
  
Background:
  Given I am logged in
  And the Question Set "qset1" exists
  And the Question Set "qset1" has the following questions:  
    | text                                           | case_string            |
    | what would python print? print 'hello world'   | question#1case#1       |
  And the following Wrong Answers exist:
    | wrong_answer_text | question                                     |
    | None              | what would python print? print 'hello world' |
  And the following Tags exist:
    | name      | description         | example    |
    | printing  | printing in python  | print 'hi' |
  And the following hints exist:
    | tag        | content                              | wrong_answer      |
    | printing   | print statements evaluate to None    | None              |
    | printing   | print takes in strings as arguments  | None              |
    | printing   | printing is not the same as return   | None              |
  And the hint threshold is 1
  And I follow "Question Sets"
  And I follow "qset"
  And I follow "printing"
  
Scenario: The concept page shows the finalized checkbox correctly
  Given I upvote the hint "print statements evaluate to None"
  Then I should be able to finalize the hint "print statements evaluate to None"
  And I should not be able to finalize the hint "print takes in strings as arguments"
  
Scenario: A user is able to finalize a hint 
  Given I upvote the hint "print statements evaluate to None"
  And I finalize the hint "print statements evaluate to None"
  Then the hint "print statements evaluate to None" should be finalized
  
Scenario: A user is able to change assigned hints for a concept
  Given the hint "print statements evaluate to None" is finalized
  And I upvote the hint "print takes in strings as arguments"
  And I finalize the hint "print takes in strings as arguments"
  Then the hint "print statements evaluate to None" should not be finalized
  And the hint "print takes in strings as arguments" should be finalized

Scenario: A user is able to unfinalize a hint
  And I upvote the hint "print statements evaluate to None"
  And I finalize the hint "print statements evaluate to None"
  And I unfinalize the hint "print statements evaluate to None"
  Then the hint "print statements evaluate to None" should not be finalized