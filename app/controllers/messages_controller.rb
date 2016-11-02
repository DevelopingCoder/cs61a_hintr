class MessagesController < ApplicationController
    
    def new
        
    end
    
    def create
        message = Message.create({:concept_id => params[:concept_id], :content => params[:add_message], :author => current_user.id}) 
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
    
end
