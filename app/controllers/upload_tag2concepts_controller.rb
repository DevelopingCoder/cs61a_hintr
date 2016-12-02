class UploadTag2conceptsController < ApplicationController
    
    def show
        format_msg = "Tag2concept file not correctly formatted. First 2 columns must be 
                        Tag,Concept"
        show_changes(Tag2concept, format_msg)
    end
    
    def confirm
        changes = aggregate_changes
        Tag2concept.save_changes(changes)        
        #get additions deletions and editions from params
        #for each of these arrays, do proper action in model
        flash[:notice] = "Success"
        redirect_to upload_path
    end
end