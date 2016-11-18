# Feature: Upload a Tags file
#   As a user, I can upload a tags csv file
#   And I can see new data as a result of the upload
  
# Background: A user account exists

#     Given the following accounts exist:
#     | name       | email                     | password          | admin |
#     | testadmin  | testadmin@gmail.com       | password          | true  |
    
#     Given the following tags exist:
#     | name        | description |
#     | Bulbasaur   | bulba!      |
#     | Charmander  | char!       |
    
#     Given the following tags csv "tags.csv" exists:
#     | Tag Name      | Description |
#     | Bulbasaur     | bulba!      |
#     | JigglyPuff    | jiggly!     |
#     | Squirtle      | squirt!     |
    
#     Given I log in with email: "testadmin@gmail.com" and password: "password"
#     And I follow "Uploads"

# Scenario: I can upload a tags file
#     Given I choose to upload a "Tags" file with "tags.csv"
#     And I press "Upload"
  
#     Then I should see "Add the tag 'JigglyPuff?'"
#     Then I should see "Add the tag 'Squirtle?'"
#     Then I should see "Delete the tag 'Charmander?'" 
  
#     When I press confirm for tag "Charmander"
#     And I press "Confirm Upload"
#     Then I should see "Success"