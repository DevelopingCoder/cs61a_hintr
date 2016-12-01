Given /^the following concepts exist:$/ do |concepts_table|
    concepts_table.hashes.each do |concept| 
        Concept.create!(concept)
    end
end

And /^the following messages exist:$/ do |messages_table| 
    messages_table.hashes.each do |message| 
        concept = Concept.find_by_name(message[:concept])
        Message.create!(:concept_id => concept.id, :content => message[:content])
    end
end

And /^I upvote "(.*)"$/ do |message|
    message_to_upvote = Message.find_by_content(message)
    step %Q{I follow "upvote-#{message_to_upvote.id}"}
end

And /^I downvote "(.*)"$/ do |message|
    message_to_downvote = Message.find_by_content(message)
    step %Q{I follow "downvote-#{message_to_downvote.id}"}
end

Then /"(.*)" should have (\d) upvotes?$/ do |message, upvotes|
    message = Message.find_by_content(message)
    page.find("#num-upvotes-#{message.id}").should have_content(upvotes)
end

Then /"(.*)" should have (\d) downvotes?$/ do |message, downvotes|
    message = Message.find_by_content(message)
    page.find("#num-downvotes-#{message.id}").should have_content(downvotes)
end

Given /^the threshold is (\d)$/ do |threshold|
    Rails.application.config.threshold = threshold
end

Then /^the threshold should be (\d)$/ do |threshold|
    expect(Rails.application.config.threshold.to_s).to eq(threshold)
    find('#threshold-display').should have_content(threshold)
end

Then /^I should be able to finalize "(.*)"$/ do |message|
    message = Message.find_by_content(message)
    expect(page).to have_selector("#finalize-#{message.id}")
end

Then /^I should not be able to finalize "(.*)"$/ do |message|
    message = Message.find_by_content(message)
    expect(page).not_to have_selector("#finalize-#{message.id}")
end

Then /^"(.*)" should be finalized$/ do |message|
    message = Message.find_by_content(message)
    expect(page).to have_selector("#assigned-message-#{message.id}")
end

Then /^"(.*)" should not be finalized$/ do |message|
    message = Message.find_by_content(message)
    expect(page).not_to have_selector("#assigned-message-#{message.id}")
end

Given /^I finalize "(.*)"$/ do |message|
    message = Message.find_by_content(message)
    step %Q{I follow "finalize-#{message.id}"}
end

Given /^I unfinalize "(.*)"$/ do |message|
    message = Message.find_by_content(message)
    step %Q{I follow "unfinalize-#{message.id}"}
end

Given /^"(.*)" is finalized$/ do |message|
    message = Message.find_by_content(message)
    message.finalize
end

Given /^"(.*)" is not finalized$/ do |message|
    message = Message.find_by_content(message)
    message.unfinalize
end

Given /^I delete "(.*)"$/ do |message| 
    message_to_delete = Message.find_by_content(message)
    step %Q{I follow "delete-#{message_to_delete.id}"}
end

Then /^I should see all the concepts$/ do
   expected_num_rows = Concept.all.size + 1 # counting the row that says what each column has
   page.should have_css("table#Concepts tr", :count => expected_num_rows)
end

When /^I sort by "(.*)"$/ do |sorter|
    step %Q{I follow "#{sorter}"}
end


Then /^(?:|I )should see "([^"]*)" before "([^"]*)"$/ do |text1, text2|
    index1 = page.body.index("#{text1}")
    index2 = page.body.index("#{text2}")
    expect(index1 < index2)
end