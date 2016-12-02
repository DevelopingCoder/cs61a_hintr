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
            type = params[:sort]
            @messages = sort_messages(type, @messages, false)
        end
        @final_message = @concept.get_finalized_message || ""
    end
    
end
