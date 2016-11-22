class UploadQuestionSetsController < ApplicationController
    before_action :authenticate_user!
    
    def show
        #uploads the file - calls model method to get additions, deletions and edits
        uploaded_file = File.open(params[:path])
        changes = QuestionSet.import(uploaded_file.read)
        @additions = changes[:additions]
        @edits = changes[:edits]
        @deletions = changes[:deletions]
    end
    
    def confirm
        #is called from the view after the confirm checkboxes are checked
        #then saves the changes we want into the db
        changes = {}
        
        confirmed_qset_additions = params[:confirmed_qset_additions]
        qset_additions = []
        if confirmed_qset_additions
            confirmed_qset_additions.each do |qset_addition|
                qset_additions += [eval(qset_addition)]   
            end
        end
        changes[:qset_additions] = qset_additions
        
        confirmed_qset_deletions = params[:confirmed_qset_deletions]
        qset_deletions = []
        if confirmed_qset_deletions
            confirmed_qset_deletions.each do |qset_deletion|
                qset_deletions += [qset_deletion]
            end
        end
        changes[:qset_deletions] = qset_deletions
        
        confirmed_question_additions = params[:confirmed_question_additions]
        question_additions = []
        if confirmed_question_additions
            confirmed_question_additions.each do |question_addition|
                question_additions += [eval(question_addition)]
            end
        end
        changes[:question_additions] = question_additions
        
        confirmed_question_edits = params[:confirmed_question_edits]
        question_edits = []
        if confirmed_question_edits
            confirmed_question_edits.each do |question_edit|
                question_edits += [eval(question_edit)]
            end 
        end
        changes[:question_edits] = question_edits
        
        confirmed_question_deletions = params[:confirmed_question_deletions]
        question_deletions = []
        if confirmed_question_deletions
            confirmed_question_deletions.each do |question_deletion|
                question_deletions += [eval(question_deletion)]
            end
        end
        changes[:question_deletions] = question_deletions
        
        QuestionSet.save_changes(changes)
        flash[:notice] = "Success"
        redirect_to upload_path    
    end

end