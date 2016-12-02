class UploadConceptsController < ApplicationController
    
    def show
        if not params.keys.include?("path")
            flash[:notice] = "Oops we lost your state. Please upload again"
            redirect_to upload_path and return
        end
        changes = Concept.import(params[:path])
        if not changes
            flash[:notice] = "Concept file not correctly formatted. First 3 columns must be
                                Name, Description, Message"
            redirect_to upload_path and return
        elsif changes.key? :error
            @error = changes[:error]
        end
        @additions = changes[:additions]
        @deletions = changes[:deletions]
        @edits = changes[:edits]
    end
    
    def confirm
        changes = aggregate_changes
        Concept.save_changes(changes)        
        #get additions deletions and editions from params
        #for each of these arrays, do proper action in model
        flash[:notice] = "Success"
        redirect_to upload_path
    end
end