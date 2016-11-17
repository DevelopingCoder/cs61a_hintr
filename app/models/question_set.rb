class QuestionSet < ActiveRecord::Base
    has_many :questions
    require 'json'
    

    def self.import(file)
        #still need to add verification
        
        
        qsets = JSON.parse(file)
        file_qsets = {}
        qsets.each do |qset|
            file_qsets[qset] = qsets[qset]
        end
        
        
    end
    
    def cross_check_diffs(file_qsets)
        #Returns a hash of answers, edits, deletions. Answers and edits contains 
        #a message, which may be an empty string if we do not want to create a new message
        edits = {}
        additions = {}
        deletions = []
        QuestionSet.all.each do |exist_qset|
            if !file_qsets.key?(exist_qset.name)
                deletions += [exist_qset.name]
            end
        end
        
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
                question_list = file_qsets[qset_name]
                db_question_list = existing_qset.questions
                #find deletions
                db_question_list.each do |question|
                    if question.text not in question_list
                        db_display_list[question_text] = question.get_wrong_answers
                end
                
                #find additions/edits
                question_list.each do |question_text|
                    question = Question.find_by_text(question_text)
                    if not question
                        # addition of question
                        upload_display_list[question_text] = question_list[question_text]
                    else
                        question_display_lists = question.find_edits(question_list[question_text])
                        if not question_display_lists[0].empty? or not question_display_lists[1].empty?
                            db_display_list[question_text] = question_display_lists[0]
                            upload_display_list[question_text] = question_display_lists[1]
                            # edits happened, add to lists accordingly
                        end
                    end
                end
                
                
                
                
                # check for edits 
                
            end
        end
        return {:additions => additions, :deletions => deletions, :edits => edits}
    end
    
#     def make_edit(exist_qset, upload_qset)
#         #Check if there's an edit. If so, change it but don't save
#         #Otherwise return False
#         edited_questions = []
#         change_discovered = false
#         #Check if description changed
#         if exist_concept.description != new_description
#             exist_concept.description = new_description
#             change_discovered = true
#         end
        
#         #Check if message should be added
#         if new_message.length > 0
#             if exist_concept.messages.find_by_content(new_message) == nil
#                 #Message doesn't exist
#                 edit[1] = new_message
#                 change_discovered = true
#             end
#         end
        
#         if change_discovered
#             return edit
#         else
#             return false
#         end
#     end
# end
