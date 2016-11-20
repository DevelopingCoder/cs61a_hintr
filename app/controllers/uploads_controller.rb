class UploadsController < ApplicationController
    
    def new
        #Based on file being uploaded, redirect to its upload controller
        file_type = params[:file_type].split()[0].downcase #(ie Concepts, Tags)
        
        #No confirmation on Users
        if file_type == "users"
            flash[:notice] = User.import(current_user, File.open(params[:file].tempfile))
            render :index
        else
            redirect_to(controller: "upload_" + file_type, action: :show, path: params[:file].path)
        end
    end
end