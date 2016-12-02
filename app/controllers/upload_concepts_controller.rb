class UploadConceptsController < ApplicationController
    
    def show
        format_msg = "Concept file not correctly formatted. First 3 columns must be
                                Name, Description, Message"
        show_changes(Concept, format_msg)
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