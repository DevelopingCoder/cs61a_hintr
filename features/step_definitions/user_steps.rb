# Step for populating the DB with users
Given /^the following accounts exist:$/ do |users_table| 
    users_table.hashes.each do |user|
        User.create!(user)
    end
end

Given /^I am on the dashboard$/ do
    pending
end

Given /^I am not logged in$/ do
    pending
end

Given /^I log in with email: "(.*)" and password: "(.*)"$/ do |email, password|
    step %Q{I am on the sign-in page}
    step %Q{I fill in "Email" with "#{email}"}
    step %Q{I fill in "Password" with "#{password}"}
    step %Q{I press "Log in"}
end

And /^I click on "([^"]*)" for "([^"]*)"$/ do |button, input|
    pending
end

Then /^I should see (\d+) users?$/ do |num|
    expect(all('tr#user').count).to eq num
end

Then /^I should see all users$/ do 
    User.all.each do |user|
        page.should have_content(user.email)
    end
end

