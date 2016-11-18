class UploadConceptsController < ApplicationController
    before_action :authenticate_user!
    
    def show
        if not params.keys.include?("path")
            flash[:notice] = "Oops we lost your state. Please upload again"
            redirect_to upload_path and return
        end
        uploaded_file = File.open(params[:path])
        changes = Concept.import(uploaded_file)
        if not changes
            flash[:notice] = "Concept File not correctly formatted correctly. First 3 columns must be
                                Name, Description, Message"
            redirect_to upload_path and return
        end
        @additions = changes[:additions]
        @deletions = changes[:deletions]
        @edits = changes[:edits]
    end
    
    def confirm
        changes = {}
        
        confirmed_additions = params[:confirmed_additions]
        additions = []
        if confirmed_additions
            confirmed_additions.each do |addition|
                additions += [eval(addition)]
            end
        end
        changes[:additions] = additions
        
        confirmed_deletions = params[:confirmed_deletions]
        deletions = []
        if confirmed_deletions
            confirmed_deletions.each do |deletion|
                deletions += [eval(deletion)]
            end
        end
        changes[:deletions] = deletions
        
        confirmed_edits = params[:confirmed_edits]
        edits = []
        if confirmed_edits 
            confirmed_edits.each do |edit|
                edits += [eval(edit)]
            end
        end
        changes[:edits] = edits
        
        Concept.save_changes(changes)        
        #get additions deletions and editions from params
        #for each of these arrays, do proper action in model
        flash[:notice] = "Success"
        redirect_to upload_path
    end
end