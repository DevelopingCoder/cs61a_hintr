class MessagesController < ApplicationController
    
    def new
        
    end
    
    def upvote
        puts "upvoted"
        message = Message.find(params[:id])
        message.vote(current_user.id, 1)
        redirect_to concept_path(params[:concept_id])
    end
    
    def downvote
        message = Message.find(params[:id])
        message.vote(current_user.id, 1)
        redirect_to concept_path(params[:concept_id])
    end
    
end
