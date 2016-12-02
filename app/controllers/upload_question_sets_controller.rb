class UploadQuestionSetsController < ApplicationController
    before_action :authenticate_user!
    
    def show
        #uploads the file - calls model method to get additions, deletions and edits
        uploaded_file = File.open(params[:path])
        changes = QuestionSet.import(uploaded_file.read)
        if changes.kind_of?(Array)
            error_msg = ""
            if changes.length == 1
                error_msg = "Tag " + changes[0] + " does not exist. Please fix this and try again."
            else
                error_msg = "Tags " + changes.join(", ") + " do not exist. Please fix this and try again."
            end
            flash[:notice] = error_msg
            redirect_to upload_path
        else
            @additions = changes[:additions]
            @edits = changes[:edits]
            @deletions = changes[:deletions]
        end
    end
    
    def confirm
        #is called from the view after the confirm checkboxes are checked
        #then saves the changes we want into the db
        changes = {}
        changes[:qset_additions] = eval_confirmed_changes(params[:confirmed_qset_additions])
        confirmed_qset_deletions = params[:confirmed_qset_deletions]
        qset_deletions = []
        if confirmed_qset_deletions
            confirmed_qset_deletions.each do |qset_deletion|
                qset_deletions += [qset_deletion]
            end
        end
        changes[:qset_deletions] = qset_deletions
        changes[:question_additions] = eval_confirmed_changes(params[:confirmed_question_additions])
        changes[:question_edits] = eval_confirmed_changes(params[:confirmed_question_edits])
        changes[:question_deletions] = eval_confirmed_changes(params[:confirmed_question_deletions])
        
        QuestionSet.save_changes(changes)
        flash[:notice] = "Success"
        redirect_to upload_path    
    end

end