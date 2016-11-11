Given /^I choose to upload a "([^"]*)" file with "([^"]*)"$/ do |type, filename|
    page.attach_file(type.downcase + "_file", Rails.root + "upload_files" + filename)
end

Given /^the following tags exist:$/ do |tags_table|
   pending 
end

Given /^the following tag to concept relations exist:$/ do |tag2concepts_table|
   pending 
end

Given /^the following concepts csv "([^"]*)" exists:$/ do |concepts_table|
   pending 
end

Given /^the following tags csv "([^"]*)" exists:$/ do |tags_table|
   pending 
end

Given /^the following tag2concepts csv "([^"]*)" exists:$/ do |tag2concepts_table|
   pending 
end

When /^I confirm the change for concept "([^"]*)"$/ do |description|
    pending
end

When /^I press "([^"]*)" for concept "([^"]*)" and tag "([^"]*)"$/ do |button, concept, tag|
    pending
end

When(/^I confirm the change for concept "([^"]*)" and tag "([^"]*)"$/) do |concept, tag|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I press confirm for tag "([^"]*)"$/) do |tag|
  pending # Write code here that turns the phrase above into concrete actions
end