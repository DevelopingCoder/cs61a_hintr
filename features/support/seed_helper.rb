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
                        wrong_answer.tags << tag
                    end
                end
            end
        end
    end
  end
end

World(SeedHelper)