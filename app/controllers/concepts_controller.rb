class ConceptsController < ApplicationController
    
    def index
        @concepts = Concept.all
    end
    
    def show
        @concept = Concept.find(params[:id])
        @messages = @concept.messages
    end
    
end
