class UploadsController < ApplicationController
    before_action :authenticate_user!
    
    def create
        #Based on file being uploaded, call their Import function
        file_types = get_file_types
        flash[:notice] = []
        if !!file_types
            file_types.each do |file|
                uploaded_file = params[file]
                type = capture_type(file)
                flash[:notice] << type.classify.constantize.send(:import, uploaded_file)
            end
        end
        redirect_to upload_path
    end
end