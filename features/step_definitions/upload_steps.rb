Given /^I choose to upload a file with "([^"]*)"$/ do |filename|
    page.attach_file("file", Rails.root + "upload_files" + filename)
end

Given /^the following tags exist:$/ do |tags_table|
    tags_table.hashes.each do |tag|
        Tag.create!(tag)
    end
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

Given /^the data in "([^"]*)" exists$/ do |filename|
    file_path = 'upload_files/' + filename
    file = File.open(file_path)
    json = JSON.parse(file.read)
    seed_db(json)
end

And /^the data in "([^"]*)" should exist in the database$/ do |filename|
    file_path = 'upload_files/' + filename
    file = File.open(file_path)
    json = JSON.parse(file.read)
    expect(diff_db(json)).to be_empty
end

Then /^the addition section should have "([^"]*)"$/ do |text|
    expect(page.find("#additions")).to have_content(text)
end

Then /^the addition section should not have "([^"]*)"$/ do |text|
    expect(page.find("#additions")).to have_no_content(text)
end

Then /^the edits section should have "([^"]*)"$/ do |text|
    expect(page.find("#edits")).to have_content(text)
end

Then /^the edits section should not have "([^"]*)"$/ do |text|
    expect(page.find("#edits")).to have_no_content(text)
end


Then /^the deletions section should have "([^"]*)"$/ do |text|
    expect(page.find("#deletions")).to have_content(text)
end

Then /^the deletions section should not have "([^"]*)"$/ do |text|
    expect(page.find("#deletions")).to have_no_content(text)
end