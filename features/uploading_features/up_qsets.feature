Feature: Upload a Questions file
  As a user, I can upload a questions json file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following tags exist:
    | name   | description        | example |
    | tag1   | description1       | ex1     |
    | tag2   | description2       | ex2     |
    | tag3   | description3       | ex3     |
    | tag4   | description4       | ex4     |
    | tag5   | description5       | ex5     |
    | tag6   | description6       | ex6     |
    | tag7   | description7       | ex7     |
    | tag8   | description8       | ex8     |
    | tag9   | description9       | ex9     |
    | tag10  | description10      | ex10    |
    Given I am logged in as an admin
    And I follow "Uploads"
    
Scenario:  I can add new question set data
  Given I select "Question_Sets (json)"
  Given I choose to upload a file with "question.json"
  When I press "Upload"
  
  Then the addition section should have "qset1"
  Then the addition section should have "question1"
  Then the addition section should have "wa1"
  Then the addition section should have "tag1"
  And the edits section should not have "qset1"
  And the edits section should not have "question1"
  And the deletions section should not have "qset1"
  
  When I check "add_qset1"
  And I check "add_qset2"
  When I press "Confirm Upload"
  Then I should see "Success"
  And the data in "question.json" should exist in the database
  
Scenario:  If I add a json the same as db no changes show
  Given the data in "question.json" exists
  And I select "Question_Sets (json)"
  Given I choose to upload a file with "question.json"
  When I press "Upload"
  
  Then the addition section should not have "qset1"
  And the addition section should not have "qset2"
  And the edits section should not have "qset1"
  And the edits section should not have "qset2"
  And the deletions section should not have "qset1"
  And the deletions section should not have "qset2"
  
  When I press "Confirm Upload"
  Then I should see "Success"
  And the data in "question.json" should exist in the database
  
Scenario: Deletions are correctly detected
  Given the data in "question.json" exists
  And I select "Question_Sets (json)"
  Given I choose to upload a file with "qsets1.json"
  When I press "Upload"
  
  Then the addition section should not have "qset1"
  And the addition section should not have "qset2"
  And the edits section should not have "qset1"
  And the edits section should not have "qset2"
  And the deletions section should have "qset2"
  And the deletions section should not have "qset1"
  
  Given I check "delete_qset2"
  When I press "Confirm Upload"
  Then I should see "Success"
  And the data in "qsets1.json" should exist in the database
  
Scenario: Question additions are correctly detected
  Given the data in "qsets2.json" exists
  And I select "Question_Sets (json)"
  And I choose to upload a file with "question.json"
  When I press "Upload"
  
  Then the addition section should not have "qset1"
  And the addition section should not have "qset2"
  And the edits section should have "qset1"
  And the edits section should not have "qset2"
  And the deletions section should not have "qset1"
  And the deletions section should not have "qset2"
  
  Given I check "edit_qset1_add_question2"
  When I press "Confirm Upload"
  Then I should see "Success"
  And the data in "question.json" should exist in the database
  
Scenario: Question deletions are correctly detected
  Given the data in "question.json" exists
  And I select "Question_Sets (json)"
  And I choose to upload a file with "qsets2.json"
  When I press "Upload"
  
  Then the addition section should not have "qset1"
  And the addition section should not have "qset2"
  And the edits section should have "qset1"
  And the edits section should not have "qset2"
  And the deletions section should not have "qset1"
  And the deletions section should not have "qset2"
  
  Given I check "edit_qset1_delete_question2"
  When I press "Confirm Upload"
  Then I should see "Success"
  And the data in "qsets2.json" should exist in the database
  
Scenario: Error is displayed if tag doesn't exist in db
  Given I select "Question_Sets (json)"
  And the tag "tag1" does not exist
  Given I choose to upload a file with "question.json"
  When I press "Upload"
  
  Then I should see "Tag tag1 does not exist. Please fix this and try again."
  And I should not see "Success"
  
Scenario: Error is displayed if tags don't exist in db
  Given I select "Question_Sets (json)"
  And the tag "tag1" does not exist
  And the tag "tag2" does not exist
  Given I choose to upload a file with "question.json"
  When I press "Upload"
  
  Then I should not see "Success"
  And I should see "Tags tag1, tag2 do not exist. Please fix this and try again."

# Convention for checkbox ids: 
# "edit_"+ qset_name+"_delete_"+ question_text
# "edit_"+ qset_name+"_edit_"+ question_text
# "edit_"+qset_name+"_add_"+question_text
# "delete_"+ qset.name
# "add_"+ qset_name

# Guide to the jsons
# question.json is base
# qsets1.json is question.json without qset2
# qsets2.json is question.json without question2 of qset1

  
  