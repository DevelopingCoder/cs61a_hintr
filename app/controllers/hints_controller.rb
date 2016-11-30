class HintsController < ApplicationController
    
    def edit_threshold
       Rails.application.config.hintthreshold = params[:threshold].to_i
       redirect_to question_sets_path
    end
    
    def create
        Hint.create({:tag2wronganswer_id => params[:tag2wronganswer_id], :content => params[:add_hint], :finalized => false})
        #Update the tag2wronganswer 
        tag2wronganswer = Tag2wronganswer.find_by_id(params[:tag2wronganswer_id])
        tag2wronganswer.update_status
        redirect_to tag2wronganswer_path(params[:tag2wronganswer_id])
    end
    
    def destroy
        hint = Hint.find(params[:id])
        hint.destroy!
        redirect_to tag2wronganswer_path(params[:tag2wronganswer_id])
    end
    
    def upvote
        hint = Hint.find(params[:id])
        hint.vote(current_user.id, 1)
        if request.xhr?
            render :json => { upvotes: hint.upvotes, downvotes: hint.downvotes, hint_id: params[:id], tag2wronganswer_id: params[:tag2wronganswer_id], action: "upvote_hint", finalizable: hint.finalizable}
        else
            redirect_to tag2wronganswer_path(params[:tag2wronganswer_id])
        end
    end
    
    def downvote
        hint = Hint.find(params[:id])
        hint.vote(current_user.id, -1)
        if request.xhr?
            render :json => { upvotes: hint.upvotes, downvotes: hint.downvotes, hint_id: params[:id], action: "downvote_hint", finalizable: hint.finalizable}
        else
            redirect_to tag2wronganswer_path(params[:tag2wronganswer_id])
        end
    end
    
    def finalize
        hint = Hint.find(params[:id])
        hint.finalize
        redirect_to tag2wronganswer_path(params[:tag2wronganswer_id])
    end
    
    def unfinalize
        hint = Hint.find(params[:id])
        hint.unfinalize
        redirect_to tag2wronganswer_path(params[:tag2wronganswer_id])
    end
end
