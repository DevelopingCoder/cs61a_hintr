class MessagesController < ApplicationController
    
    def new
        
    end
    
    def edit_threshold
       Rails.application.config.threshold = params[:threshold].to_i
       redirect_to concepts_path
    end
    
    def create
        Message.create({:concept_id => params[:concept_id], :content => params[:add_message], :author => current_user.id, :finalized => false})
        #Update the concept 
        concept = Concept.find_by_id(params[:concept_id])
        concept.update_status
        redirect_to concept_path(params[:concept_id])
    end
    
    def destroy
        message = Message.find(params[:id])
        message.destroy!
        redirect_to concept_path(params[:concept_id])
    end
    
    def upvote
        message = Message.find(params[:id])
        message.vote(current_user.id, 1)
        if request.xhr?
            render :json => { upvotes: message.upvotes, downvotes: message.downvotes, message_id: params[:id], concept_id: params[:concept_id], action: "upvote", finalizable: message.finalizable}
        else
            redirect_to concept_path(params[:concept_id])
        end
    end
    
    def downvote
        message = Message.find(params[:id])
        message.vote(current_user.id, -1)
        if request.xhr?
            render :json => { upvotes: message.upvotes, downvotes: message.downvotes, message_id: params[:id], action: "downvote", finalizable: message.finalizable}
        else
            redirect_to concept_path(params[:concept_id])
        end
    end
    
    def finalize
        message = Message.find(params[:id])
        message.finalize
        redirect_to concept_path(params[:concept_id])
    end
    
    def unfinalize
        message = Message.find(params[:id])
        message.unfinalize
        redirect_to concept_path(params[:concept_id])
    end
    
end