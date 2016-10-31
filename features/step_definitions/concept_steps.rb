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
    pending # get the message and increment its upvotes
end

And /^I downvote "(.*)"$/ do |message|
    pending # get the message and increment its downvotes
end

Then /"(.*)" should have (\d) upvotes?$/ do |message, upvotes|
    pending
end

Then /"(.*)" should have (\d) downvotes?$/ do |message, upvotes|
    pending
end

Then /^I should see all the concepts$/ do
   expected_num_rows = Concept.all.size + 1 # counting the row that says what each column has
   page.should have_css("table#Concepts tr", :count => expected_num_rows)
end