# Step for populating the DB with users
Given /^the following accounts exist:$/ do |users_table| 
    users_table.hashes.each do |user|
        User.create!(user)
    end
end

Given /^I log in with email: "(.*)" and password: "(.*)"$/ do |email, password|
    step %Q{I am on the sign-in page}
    step %Q{I fill in "Email" with "#{email}"}
    step %Q{I fill in "Password" with "#{password}"}
    step %Q{I press "Log in"}
end

Then /^I should see all users$/ do 
    User.all.each do |user|
        page.should have_content(user.email)
    end
end

# Given /^I am on (.*)$/ do |page|
#     visit path_to(page)
# end

And /^I logout$/ do
  current_driver = Capybara.current_driver
  Capybara.current_driver = :rack_test
  page.driver.submit :delete, path_to("the logout page"), {}
  Capybara.current_driver = current_driver 
end