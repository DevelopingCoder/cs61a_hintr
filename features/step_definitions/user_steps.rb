# Step for populating the DB with users
Given /^the following accounts exist:$/ do |users_table| 
    users_table.hashes.each do |user|
        Movie.create user
    end
end

Given /^I visit (.*)$/ do |page|
    visit path_to(page)
end

Given /^I am on the dashboard$/ do
    pending
end

Given /^I am not logged in$/ do
    pending
end

Given /^I log in with email: "(.*)" and password: "(.*)"$/ do
    pending
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

And /^I click on "([^"]*)" for "([^"]*)"$/ do |button, input|
    pending
end

Then /^I should( not)? be on (.*)$/ do |not_on_page, page|
    pending
end

Then /^I should( not)? see "([^"]*)"$/ do |value|
    pending
end

Then /^I should see all users$/ do 
    pending
end

