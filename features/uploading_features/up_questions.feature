Feature: Upload a Questions file
  As a user, I can upload a questions json file
  And I can see new data as a result of the upload
  
Background: A user account exists

    Given the following accounts exist:
    | name       | email                     | password          | admin |
    | testadmin  | testadmin@gmail.com       | password          | true  |
    
    Given the following question json "questionData.json" exists:
    | Question        | Wrong Answer                      | Tag                               |
    | test_question 1 | wrong_answer 1, wrong_answer 2    | question tag_1                    |
    | test_question 2 | wrong_answer 2                    | question tag_1, question tag_2    |
    | test_question 3 | wrong_answer 3                    | question tag_1                    |
     
    Given I log in with email: "testadmin@gmail.com" and password: "password"
    And I follow "Uploads
      
     
Scenario: I can upload a question file successfully
    Given I choose to upload a "Question" file with "questionData.json"
    And I press "Upload"
    And I press "Confirm Upload"
    Then I should see "Success"
    
    When I am on the questions page
    Then I should see "test_question 1"
    And I should see "test_question 2"
    And I should see "test_question 3"
    
    When I follow "test_question 1"
    Then I should see tag "question tag_1"
    
    