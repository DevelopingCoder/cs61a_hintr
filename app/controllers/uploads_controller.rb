class UploadsController < ApplicationController
    before_action :authenticate_user!
    
    def new
        #Based on file being uploaded, redirect to its upload controller
        file_type = params[:file_type].split()[0].downcase #(ie Concept, Tag)
        redirect_to(controller: "upload_" + file_type, action: :show, path: params[:file].path)
    end
end