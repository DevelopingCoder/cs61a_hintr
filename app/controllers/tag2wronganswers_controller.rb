class Tag2wronganswersController < ApplicationController
    
    def show
        @tag2wronganswer = Tag2wronganswer.find(params[:id])
        @wrong_answer = @tag2wronganswer.wrong_answer
        @hints = @tag2wronganswer.hints
    end
end
