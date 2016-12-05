class QuestionSet < ActiveRecord::Base
    has_many :questions, dependent: :destroy
    require 'json'
    

    def self.import(file)
        #still need to add verification
        qsets = JSON.parse(file)
        file_qsets = {}
        qsets.each do |qset_name, qset_hash|
            file_qsets[qset_name] = qset_hash
        end
        no_tag_error = check_tags_exist(file_qsets)
        if no_tag_error.length != 0
            return no_tag_error
        end
        return cross_check_diffs(file_qsets)
        
    end
    
    def self.check_tags_exist(file_qsets)
        non_exist_tags = []
        file_qsets.keys.each do |qset_name|
            question_hash = file_qsets[qset_name]
            question_hash.each do |question_text, wrong_answer_list|
                wrong_answer_list.each do |wrong_answer_text, tag_list|
                    if wrong_answer_text != "CASE_STR"
                       tag_list.each do |tag_name|
                            existing_tag = Tag.where("lower(name) = ?", tag_name.downcase)
                            if not existing_tag or not existing_tag.first
                                if not non_exist_tags.include?(tag_name)
                                    non_exist_tags << tag_name
                                end
                            end
                        end 
                    end
                end
            end
        end
        return non_exist_tags
    end
    
    def self.cross_check_diffs(file_qsets)
        #Returns a hash of answers, edits, deletions. Answers and edits contains 
        #a message, which may be an empty string if we do not want to create a new message
        edits = {}
        additions = {}
        deletions = QuestionSet.find_deletions(file_qsets)
        #check additions and edits
        file_qsets.keys.each do |qset_name|
            #Check if questionset not in db
            existing_qset = QuestionSet.find_by_name(qset_name)
            if not existing_qset
                additions[qset_name] = file_qsets[qset_name]
            else
                # check for edits
                db_display_list = {} # questions shown (edited or deleted)
                upload_display_list = {} #questions shown (edited or added)
                question_hash = file_qsets[qset_name]
                db_question_list = existing_qset.questions
                #find deletions
                db_question_list.each do |question|
                    if not question_hash.key?(question.text)
                        db_display_list[question.text] = question.get_wrong_answers
                    end
                end
                #find additions/edits
                QuestionSet.find_additions_and_edits(question_hash, upload_display_list, db_display_list)
                if not (db_display_list.empty? and upload_display_list.empty?)
                    edits[qset_name] = [db_display_list, upload_display_list]
                end
            end
        end
        return {:additions => additions, :deletions => deletions, :edits => edits}
    end
    
    def self.find_additions_and_edits(question_hash, upload_display_list, db_display_list)
        question_hash.each do |question_text, wa_hash|
            question = Question.find_by_text(question_text)
            if not question
                # addition of question
                upload_display_list[question_text] = wa_hash
            else
                question_display_lists = question.find_edits(question_hash[question_text])
                if not question_display_lists[0].empty? or not question_display_lists[1].empty?
                    db_display_list[question_text] = question_display_lists[0]
                    upload_display_list[question_text] = question_display_lists[1]
                    # edits happened, add to lists accordingly
                end
            end
        end
    end
    
    def self.find_deletions(file_qsets)
        deletions = []
        QuestionSet.all.each do |exist_qset|
            if !file_qsets.key?(exist_qset.name)
                deletions += [exist_qset]
            end
        end
        return deletions
    end
    
    def self.save_changes(changes)
        qset_additions = changes[:qset_additions]
        qset_deletions = changes[:qset_deletions]
        qset_deletions.each do |qset_deletion|
            QuestionSet.find_by_name(qset_deletion).destroy
        end
        
        # sadly, qset_additions is a list of hashes, in which each hash has only one pair, a qset name mapping to a hash of questions
        qset_additions.each do |qset_hash|
            qset_hash.each do |qset_name, question_hash|
                qset = QuestionSet.create(:name => qset_name)
                question_hash.each do |question_text, wa_hash|
                    question = Question.create(:text => question_text, :case_string => wa_hash["CASE_STR"])
                    wa_hash.each do |wa_text, tag_list|
                        if wa_text != "CASE_STR"
                            wrong_answer = WrongAnswer.create(:text => wa_text)
                            wrong_answer.associate_tags(tag_list)
                            question.wrong_answers << wrong_answer
                        end
                    end
                    qset.questions << question
                end
            end
        end
        
        question_additions = changes[:question_additions]
        QuestionSet.add_questions(changes[:question_additions])
        QuestionSet.apply_edits(changes[:question_edits])
        QuestionSet.delete_questions(changes[:question_deletions])
        
    end
    
    def self.add_questions(question_additions)
        question_additions.each do |qset_name, question_text, wa_hash|
            qset = QuestionSet.find_by_name(qset_name)
            question = Question.create(:text => question_text, :case_string => wa_hash["CASE_STR"])
            wa_hash.each do |wa_text, tag_list|
                if wa_text != "CASE_STR"
                    wrong_answer = WrongAnswer.create(:text => wa_text)
                    wrong_answer.associate_tags(tag_list)
                    question.wrong_answers << wrong_answer
                end
            end
            qset.questions << question
        end
    end
    
    def self.delete_questions(question_deletions)
        question_deletions.each do |qset_name, question_text|
            qset = QuestionSet.find_by_name(qset_name)
            qset.questions.each do |question|
                if question.text == question_text
                    question.destroy
                end
            end
        end
    end
    
    def self.apply_edits(question_edits)
        question_edits.each do |qset_name, question_text, wa_hash|
            qset = QuestionSet.find_by_name(qset_name)
            question = Question.create(:text => question_text, :case_string => wa_hash["CASE_STR"])
            wa_hash.each do |wa_text, tag_list|
                if wa_text != "CASE_STR"
                    wrong_answer = WrongAnswer.create(:text => wa_text)
                    wrong_answer.associate_tags(tag_list)
                    question.wrong_answers << wrong_answer
                end
            end
            qset.questions << question
        end
    end
    
    
end
    