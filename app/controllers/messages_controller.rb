class MessagesController < ApplicationController
    
    def new
        
    end
    
    def edit_threshold
       Rails.application.config.threshold = params[:threshold].to_i
       redirect_to concepts_path
    end
    
    def create
        message = Message.create({:concept_id => params[:concept_id], :content => params[:add_message], :author => current_user.id, :finalized => false})
        concept = Concept.find(params[:concept_id])
        if concept.msg_status == 'no messages'
            concept.update_attribute(:msg_status, 'in progress')
        end
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
        redirect_to concept_path(params[:concept_id])
    end
    
    def downvote
        message = Message.find(params[:id])
        message.vote(current_user.id, -1)
        redirect_to concept_path(params[:concept_id])
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