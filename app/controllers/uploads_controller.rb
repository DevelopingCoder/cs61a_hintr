class UploadsController < ApplicationController
    before_action :authenticate_user!
    
    def new
        #Based on file being uploaded, call their Import function
        file_types = get_file_types
        # flash[:notice] = []
        if !!file_types
            file_types.each do |file|
                uploaded_file = File.open(params[file].tempfile)
                type = capture_type(file)
                changes = type.classify.constantize.send(:import, uploaded_file)
                @additions = changes[:additions]
                @deletions = changes[:deletions]
                @edits = changes[:edits]
            end
        end
    end
    
    def show
        
    end
    
    def confirm
        changes = {}
        additions = []
        deletions = []
        edits = []
        confirmed_additions = params[:confirmed_additions]
        if confirmed_additions
            confirmed_additions.each do |addition|
                additions += [eval(addition)]
            end
        end
        changes[:additions] = additions
        
        confirmed_deletions = params[:confirmed_deletions]
        if confirmed_deletions
            confirmed_deletions.each do |deletion|
                deletions += [eval(deletion)]
            end
        end
        changes[:deletions] = deletions
        
        confirmed_edits = params[:confirmed_edits]
        if confirmed_edits 
            confirmed_edits.each do |edit|
                edits += [eval(edit)]
            end
        end
        changes[:edits] = edits
        
        Concept.save_changes(changes)        
        #get additions deletions and editions from params
        #for each of these arrays, do proper action in model
        redirect_to upload_path
    end
    
end