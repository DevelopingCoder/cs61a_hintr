Feature: Change hint threshold
  
  As a hintr admin
  So that I can control the finalization of hints
  I want to be able to change the threshold of upvotes a hint needs to be finalized
 
Background:
  Given the hint threshold is 3
  
Scenario: An admin can change the threshold
  Given I am logged in as an admin
  And I follow "Question Sets"
  Then the hint threshold should be 3
  
  Given I fill in "threshold" with "1"
  And I press "Change"
  Then the hint threshold should be 1
  
Scenario: A nonadmin cannot change the threshold
  Given I am logged in
  And I follow "Question Sets"
  Then I should not see "Current threshold"