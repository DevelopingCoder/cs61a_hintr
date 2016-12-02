And /^the Question Set "(.*)" exists$/ do |qset_name|
    QuestionSet.create!(:name => qset_name)
end

Given(/^the Question Set "([^"]*)" has the following questions:$/) do |qset_name, questions_table|
    qset = QuestionSet.find_by_name(qset_name)
    questions_table.hashes.each do |question| 
        qset.questions.create!(question)
    end
end

Given /^the following Wrong Answers? exists?:$/ do |wrong_answers_table|
    wrong_answers_table.hashes.each do |info|
        question = Question.find_by_text(info["question"])
        question.wrong_answers.create!(:text => info["wrong_answer_text"])
    end
end

Given /^the following Tags? exists?:$/ do |tags_table|
    tags_table.hashes.each do |tag|
        Tag.create!(tag)
    end
end

Given /^the following hints? exists?:$/ do |hints_table|
    hints_table.hashes.each do |info|
        wrong_answer = WrongAnswer.find_by_text(info["wrong_answer"])
        tag = Tag.find_by_name(info["tag"])
        if not wrong_answer.tags.include?(tag)
            wrong_answer.tags << tag
        end
        tag2wronganswer = Tag2wronganswer.where(:tag_id => tag.id).where(:wrong_answer_id => wrong_answer.id).first
        tag2wronganswer.hints.create!(:content => info["content"])
    end
end

And /^I upvote the hint "(.*)"$/ do |hint|
    hint_to_upvote = Hint.find_by_content(hint)
    step %Q{I follow "upvote-#{hint_to_upvote.id}"}
end

And /^I downvote the hint "(.*)"$/ do |hint|
    hint_to_downvote = Hint.find_by_content(hint)
    step %Q{I follow "downvote-#{hint_to_downvote.id}"}
end

Then /the hint "(.*)" should have (\d) upvotes?$/ do |hint, upvotes|
    hint = Hint.find_by_content(hint)
    page.find("#num-upvotes-#{hint.id}").should have_content(upvotes)
end

Then /the hint "(.*)" should have (\d) downvotes?$/ do |hint, downvotes|
    hint = Hint.find_by_content(hint)
    page.find("#num-downvotes-#{hint.id}").should have_content(downvotes)
end

Then /^I should be able to finalize the hint "(.*)"$/ do |hint|
    hint = Hint.find_by_content(hint)
    expect(page).to have_selector("#finalize-#{hint.id}")
end

Then /^I should not be able to finalize the hint "(.*)"$/ do |hint|
    hint = Hint.find_by_content(hint)
    expect(page).not_to have_selector("#finalize-#{hint.id}")
end

Then /^the hint "(.*)" should be finalized$/ do |hint|
    hint = Hint.find_by_content(hint)
    expect(page).to have_selector("#assigned-hint-#{hint.id}")
end

Then /^the hint "(.*)" should not be finalized$/ do |hint|
    hint = Hint.find_by_content(hint)
    expect(page).not_to have_selector("#assigned-hint-#{hint.id}")
end

Given /^I finalize the hint "(.*)"$/ do |hint|
    hint = Hint.find_by_content(hint)
    step %Q{I follow "finalize-#{hint.id}"}
end

Given /^I unfinalize the hint "(.*)"$/ do |hint|
    hint = Hint.find_by_content(hint)
    step %Q{I follow "unfinalize-#{hint.id}"}
end

Given /^the hint "(.*)" is finalized$/ do |hint|
    hint = Hint.find_by_content(hint)
    hint.finalize
end

Given /^the hint "(.*)" is not finalized$/ do |hint|
    hint = Hint.find_by_content(hint)
    hint.unfinalize
end

Given /^I delete the hint "(.*)"$/ do |hint| 
    hint_to_delete = Hint.find_by_content(hint)
    step %Q{I follow "delete-#{hint_to_delete.id}"}
end

Given /^the hint threshold is (\d)$/ do |threshold|
    Rails.application.config.hintthreshold = threshold
end

Then /^the hint threshold should be (\d)$/ do |threshold|
    expect(Rails.application.config.hintthreshold.to_s).to eq(threshold)
    find('#threshold-display').should have_content(threshold)
end


