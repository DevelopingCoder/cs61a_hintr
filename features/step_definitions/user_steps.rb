# Step for populating the DB with users
Given /^the following accounts exist:$/ do |users_table| 
    users_table.hashes.each do |user|
        User.create!(user)
    end
end

Given /^I log in with email: "([^"]*)" and password: "([^"]*)"$/ do |email, password|
    step %Q{I am on the sign-in page}
    step %Q{I fill in "Email" with "#{email}"}
    step %Q{I fill in "Password" with "#{password}"}
    step %Q{I press "Log in"}
end

Given /^I am logged in$/ do
    User.create!(:name => "testuser", :email => "testuser@gmail.com", :password => "password", :admin => false)
    step %Q{I log in with email: "testuser@gmail.com" and password: "password"}
end

Then /^I should see all users$/ do 
    User.all.each do |user|
        page.should have_content(user.email)
    end
end

And /^I logout$/ do
  step %Q{I follow "Logout"}
end

Then /^"([^"]*)" should (not )?be an admin$/ do |email, not_admin|
    truth_value = (not_admin != "not ")
    user = User.find_by_email(email)
    expect(user.admin).to be truth_value
end

Then /^the delete checkbox for "([^"]*)" should be disabled$/ do |email|
    expect(page.find_by_id("delete_#{email}").disabled?).to be true
end

When /^I (un)?check the delete checkbox for "([^"]*)"$/ do |uncheck, email|
    is_check = uncheck != "un"
    id = "delete_checkbox_" + User.find_by_email(email).id.to_s
    if is_check
        check(id)
    else
        uncheck(id)
    end
end

Then /^the admin checkbox for "([^"]*)" should be disabled$/ do |email|
    user = User.find_by_email(email)
    expect(page.find_by_id("admin_checkbox_#{user.name}").disabled?).to be true
end

When /^I (un)?check the admin checkbox for "([^"]*)"$/ do |uncheck, email|
    is_check = uncheck != "un"
    id = "admin_checkbox_" + User.find_by_email(email).name
    if is_check
        check(id)
    else
        uncheck(id)
    end
end

When /^I am should see "Successfully deleted"$/ do
    byebug
end
        