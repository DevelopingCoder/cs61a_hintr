Given /^I am logged in$/ do
    step %Q{
        Given the following accounts exist:
        | name       | email                     | password          | admin |
        | testuser   | testuser@gmail.com        | password          | false |
    }
    step %Q{I log in with email: "testuser@gmail.com" and password: "password"}
end

Given /^the following concepts exist:$/ do |concepts_table| 
    pending # create concept models
end

And /^the following comments exist:$/ do |comments_table| 
    pending # create comment models
end

And /^I upvote "(.*)"$/ do |comment|
    pending # get the comment and increment its upvotes
end

And /^I downvote "(.*)"$/ do |comment|
    pending # get the comment and increment its downvotes
end

Then /"(.*)" should have (\d) upvotes?$/ do |comment, upvotes|
    pending
end

Then /"(.*)" should have (\d) downvotes?$/ do |comment, upvotes|
    pending
end

Then /^I should see all the concepts$/ do
   pending 
end