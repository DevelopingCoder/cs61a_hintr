class UploadTag2conceptsController < ApplicationController
    def show
        if not params.keys.include?("path")
            flash[:notice] = "Oops we lost your state. Please upload again"
            redirect_to upload_path and return
        end
        changes = Tag2concept.import(params[:path])
        if not changes
            flash[:notice] = "Tag2concept file not correctly formatted. First 2 columns must be 
                Tag,Concept"
            redirect_to upload_path and return
        elsif changes.key? :error
            @error = changes[:error]
        end
        @additions = changes[:additions]
        @deletions = changes[:deletions]
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
        
        Tag2concept.save_changes(changes)        
        #get additions deletions and editions from params
        #for each of these arrays, do proper action in model
        flash[:notice] = "Success"
        redirect_to upload_path
    end
end