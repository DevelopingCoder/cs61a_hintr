# Step for populating the DB with users
Given /^the following accounts exist:$/ do |users_table| 
    users_table.hashes.each do |user|
        Movie.create user
    end
end

Given /^I am on (.*)$/ do |page|
    step("I visit #{page}")
end

Given /^I log in with email: "(.*)" and password: "(.*)"$/ do |email, pass|
    visit path_to("login")
    fill_in("user_email", :with => email)
    fill_in("user_password", :with => pass)
    click_button("commit")
end    
    
# Then /^I should see (\d+) users?$/ do |num|
#     expect(all('tr#user').count).to eq num
# end

