class Question < ActiveRecord::Base
    belongs_to :question_set
    has_many :wrong_answers
    has_many :tag2wronganswers
    has_many :tags, :through => :tag2wronganswers
    require 'json'
    
    def find_edits(wrong_answer_list)
        db_display_list = {} # wrong answers shown (edited or deleted)
        upload_display_list = {} #wrong answers shown (edited or added)
        
        db_wrong_answer_list = self.wrong_answers
        ##find deletions
        db_wrong_answer_list.each do |wrong_answer|
            if wrong_answer.text not in wrong_answer_list
                #deletions
                db_display_list[wrong_answer.text] = wrong_answer.get_tags
            end
        end
        
        wrong_answer_list.each do |wrong_answer_text|
            wrong_answer = WrongAnswer.find_by_text(wrong_answer_text)
            if wrong_answer
                #wrong answer exists in db - check for edits
                if wrong_answer.is_edited
                    db_display_list[wrong_answer_text] = wrong_answer.get_tags
                    upload_display_list[wrong_answer_text] = wrong_answer_list[wrong_answer_text]
            else
                #wrong answer is an addtion
                upload_display_list[wrong_answer_text] = wrong_answer_list[wrong_answer_text]
        end
        return [db_display_list, upload_display_list]
    end
    
    
    def get_wrong_answers
        list_of_wrong_answers = {}
        self.wrong_answers.each do |wrong_answer|
            list_of_wrong_answers[wrong_answer.text] = wrong_answer.get_tags
        end
        return list_of_wrong_answers
    end
    
end
