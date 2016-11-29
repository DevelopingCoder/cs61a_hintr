module SeedHelper
  def seed_db(qset_json)
    # seed db with qsets in json, expect it to be in same format as question.json
    # also assumes an empty database except for tags (doesn't check for new questions, qsets, or was)
    # so all tags in the seed json should be within tag1-tag10
    qset_json.each do |qset_name, question_json|
        qset = QuestionSet.create!(:name => qset_name)
        question_json.each do |question_text, wa_json| 
            question = qset.questions.create!(:text => question_text, :case_string => wa_json["CASE_STR"])
            wa_json.each do |wa_text, tag_list|
                if wa_text != "CASE_STR"
                    wrong_answer = question.wrong_answers.create!(:text => wa_text)
                    tag_list.each do |tag_name|
                        tag = Tag.find_by_name(tag_name)
                        if not tag
                            tag = Tag.create!(:name => tag_name, :description => "test_tag_descript", :example => "test_tag_example") 
                        end
                        wrong_answer.tags << tag
                    end
                end
            end
        end
    end
  end
  
    # returns diffs between db and qset_json (checks associations too)
    # for now only checks for things in json that are NOT in db 
    def diff_db(qset_json)
        diffs = []
        qset_json.each do |qset_name, question_json|
            question_set = QuestionSet.find_by_name(qset_name)
            if not question_set
                diffs += [qset_name]
                next
            end
            question_json.each do |question_text, wa_json| 
                question = Question.find_by_text(question_text)
                if not question or not question_set.questions.include?(question)
                    diffs += [question_text]
                    next
                end
                wa_json.each do |wa_text, tag_list|
                    if wa_text != "CASE_STR"
                        wrong_answer = WrongAnswer.find_by_text(wa_text)
                        if not wrong_answer or not question.wrong_answers.include?(wrong_answer)
                            diffs += [wa_text]
                            next
                        end
                        tag_list.each do |tag_name|
                            tag = Tag.find_by_name(tag_name)
                            if not tag or not wrong_answer.tags.include?(tag)
                                diffs += [tag_name]
                                next
                            end
                        end
                    end
                end
            end
        end
        return diffs
    end
  
end

World(SeedHelper)
