Feature: Upload a Questions file
  As a user, I can upload a questions json file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following tags exist:
    | name   | description        |
    | tag1   | description1       |
    | tag2   | description2       |
    | tag3   | description3       |
    | tag4   | description4       |
    | tag5   | description5       |
    | tag6   | description6       |
    | tag7   | description7       |
    | tag8   | description8       |
    | tag9   | description9       |
    | tag10  | description10      |
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
  
Scenario:  If I add a json the same as db no changes show
  Given the data in "question.json" exists
  And I select "Question_Sets (json)"
  Given I choose to upload a file with "question.json"
  When I press "Upload"
  
  Then the addition section should not have "qset1"
  Then the edits section should not have "qset1"
  Then the deletions section should not have "qset1"
  
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
  
  
  
  