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
    # click_on("upvote-#{message_to_upvote.id}")
    # page.find("upvote-#{message_to_upvote.id}")
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

Given /^I delete "(.*)"$/ do |message| 
    message_to_delete = Message.find_by_content(message)
    # step %Q{I follow "Delete-#{message_to_delete.id}"}
    step %Q{I follow "delete-#{message_to_delete.id}"}
end

Then /^I should see all the concepts$/ do
   expected_num_rows = Concept.all.size + 1 # counting the row that says what each column has
   page.should have_css("table#Concepts tr", :count => expected_num_rows)
end