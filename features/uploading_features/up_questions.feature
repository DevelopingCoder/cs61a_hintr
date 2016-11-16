Feature: Upload a Questions file
  As a user, I can upload a questions json file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true  |
     
    Given "questionData.json" is used for data 
    # Given the following questions exist:
    # | Question        | Wrong Answer                      | Tag                               | case_str  |
    # | test_question 3 | wrong_answer 3                    | question tag_1                    | x3        |
    
    # Given the following questions json "questionData.json" exists:
    # | Question        | Wrong Answer                      | Tag                               | case_str  |
    # | test_question 1 | wrong_answer 1, wrong_answer 2    | question tag_1                    | x1        | 
    # | test_question 2 | wrong_answer 2                    | question tag_1, question tag_2    | x2        | 
    # | test_question 3 | wrong_answer 3, wrong_answer 4    | question tag_2                    | x3        |
     
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads
      
     
Scenario: I can upload a questions file successfully
    Given I choose to upload a "Question" file with "questionData.json"
    And I press "Upload"
    
    And I should see "Add the question 'test_question 1'"
    And I should see "Add the question 'test_question 2'"
    And I should see ".Edit the question 'test_question 3'"
    
    When I confirm the change for question "test_question 3"
    And I press "Confirm Update"
    Then I should see "Success"
    
    When I am on the questions page
    Then I should see "test_question 1"
    And I should see "test_question 2"
    And I should see "test_question 3"
    
    When I follow "test_question 1"
    Then I should see tag "question tag_1"
    And I should see wrong_answer "wrong_answer 1"
    And I should see wrong_answer "wrong_answer 2"
    
    When I am on the questions page
    When I follow "test_question 3"
    Then I should see tag "question tag_2"
    And I should see wrong_answer "wrong_answer 3"
    And I should see wrong_answer "wrong_answer 4"
    
Scenario: Not pressing confirm when uploading questions doesn't make changes
    Given I choose to upload a "Question" file with "questionData.json"
    When I press "Upload"
    Then I should be on the upload confirmation page
    
    When I am on the questions page
    When I follow "test_question 3"
    Then I should not see "wrong_answer 4"
    
    
    
    
    
    