class ConceptsController < ApplicationController
    
    def index
        @concepts = Concept.all
        @concepts.each do |concept|
            concept.update_status
        end
        @threshold = Rails.application.config.threshold
    end
    
    def show
        @concept = Concept.find(params[:id])
        @messages = @concept.messages
        if params.has_key?("sort")
            message_upvotes = {}
            message_downvotes = {}
            @messages.each do |message|
                upvotes = 0
                downvotes = 0
                message.votes.each do |vote|
                    if vote.vote_type > 0
                        upvotes += 1
                    elsif vote.vote_type < 0
                        downvotes += 1
                    end
                end
                #Negate because we sort by smallest to largest
                message_upvotes[message] = -upvotes
                message_downvotes[message] = -downvotes
            end
            if params[:sort] == "upvotes"
                @messages = message_upvotes.sort_by{|k,v| v}.map{|k,v| k}
            elsif params[:sort] == "downvotes"
                @messages = message_downvotes.sort_by {|k,v| v}.map{|k,v| k}
            end

        end
        @final_message = @concept.get_finalized_message || ""
    end
    
end
