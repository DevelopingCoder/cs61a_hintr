class Tag2wronganswersController < ApplicationController
    
    def show
        @tag2wronganswer = Tag2wronganswer.find(params[:id])
        @wrong_answer = @tag2wronganswer.wrong_answer
        @hints = @tag2wronganswer.hints
        if params.has_key?("sort")
            type = params[:sort]
            @hints = sort_messages(type, @hints, true)
        end
        @final_message = @tag2wronganswer.get_finalized_hint || ""
    end
end
