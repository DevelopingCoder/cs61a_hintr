Given /^the following Questions? exists?:$/ do |questions_table|
    questions_table.hashes.each do |question| 
        Question.create!(question)
    end
end

Given /^the following Wrong Answers? exists?:$/ do |wrong_answers_table|
    wrong_answers_table.hashes.each do |wrong_answer|
        Wrong_Answer.create!(wrong_answer)
    end
end

Given /^the following Tags? exists?:$/ do |tags_table|
    tags_table.hashes.each do |tag|
        Tag.create!(tag)
    end
end

Given /^the following Hints? exists?:$/ do |hints_table|
    hints_table.hashes.each do |hint|
        Hint.create!(hint)
    end
end


