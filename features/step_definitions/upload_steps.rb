Given /^I choose to upload a file with "([^"]*)"$/ do |filename|
    page.attach_file("file", Rails.root + "upload_files" + filename)
end

Given /^the following tags exist:$/ do |tags_table|
   pending 
end

Given /^the following tag to concept relations exist:$/ do |tag2concepts_table|
   pending 
end

Given /^I select "([^"]*)"$/ do |selection|
    page.select(selection)
end
Given /^the following "([^"]*)" exists:$/ do |filename, concepts_table|
    file_info = ""
    concepts_table.hashes.each do |concept|
        titles = []
        if file_info.blank?
            concept.each do |value|
                titles << value[0]
            end
            titles = titles.join(',')
            file_info += titles + "\n"
        end
        curr_concept = []
        concept.each do |value|
            curr_concept << value[1]
        end
        curr_concept = curr_concept.join(',')
        file_info+= curr_concept + "\n"
    end
    File.write('upload_files/'+filename, file_info)
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