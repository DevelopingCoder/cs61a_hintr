class Tag2wronganswersController < ApplicationController
    
    def show
        @tag2wronganswer = Tag2wronganswer.find(params[:id])
        @wrong_answer = @tag2wronganswer.wrong_answer
        @hints = @tag2wronganswer.hints
        if params.has_key?("sort")
            message_upvotes = {}
            message_downvotes = {}
            @hints.each do |message|
                upvotes = 0
                downvotes = 0
                message.hint_votes.each do |vote|
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
                @hints = message_upvotes.sort_by{|k,v| v}.map{|k,v| k}
            elsif params[:sort] == "downvotes"
                @hints = message_downvotes.sort_by {|k,v| v}.map{|k,v| k}
            end
        end
        @final_message = @tag2wronganswer.get_finalized_hint || ""
    end
end
