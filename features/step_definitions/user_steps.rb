# Step for populating the DB with users
Given /^the following accounts exist:$/ do |users_table| 
    users_table.hashes.each do |user|
        User.create user
    end
end

Given /^I am on (.*)$/ do |page|
    visit path_to(page)
end

Given /^I log in with email: "(.*)" and password: "(.*)"$/ do |email, pass|
    visit path_to("the login page")
    fill_in("user_email", :with => email)
    fill_in("user_password", :with => pass)
    click_button("Login")
end    

And /^I logout$/ do
  current_driver = Capybara.current_driver
  Capybara.current_driver = :rack_test
  page.driver.submit :delete, path_to("the logout page"), {}
  Capybara.current_driver = current_driver 
end
    
# Then /^I should see (\d+) users?$/ do |num|
#     expect(all('tr#user').count).to eq num
# end

