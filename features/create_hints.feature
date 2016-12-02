Feature: hint creation 
  
  As a hintr user
  So that I can create hints on concepts
  I want to be able to draft and submit a hint for a given concepts
  
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
    | printing   | print takes in strings as arguments  | None              |
    | printing   | printing is not the same as return   | None              |
  
  And I follow "Question Sets"
  And I follow "qset"
  And I follow "printing"
 
Scenario: Create a valid hint 
  Given I fill in "add_hint" with "print statements evaluate to None"
  And I press "Post hint"
  Then I should see "in progress"
  Then I should see "print statements evaluate to None"