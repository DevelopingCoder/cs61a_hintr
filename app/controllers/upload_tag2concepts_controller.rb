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
        params[:confirmed_edits] = [] #Do this just to maintain DRYness        
        changes = aggregate_changes
        Tag2concept.save_changes(changes)        
        #get additions deletions and editions from params
        #for each of these arrays, do proper action in model
        flash[:notice] = "Success"
        redirect_to upload_path
    end
end