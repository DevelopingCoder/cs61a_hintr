class UploadTagsController < ApplicationController
    
    def show
        format_msg = "Tag file not correctly formatted. First 10 columns must be 
                Old tag name,cp,Status,Tag Name,Description,Example,Primary Concept,Topic,Count in Tag to Concept Master,Concepts"
        show_changes(Tag, format_msg)
    end
    
    def confirm
        changes = aggregate_changes
        Tag.save_changes(changes)        
        #get additions deletions and editions from params
        #for each of these arrays, do proper action in model
        flash[:notice] = "Success"
        redirect_to upload_path
    end
end