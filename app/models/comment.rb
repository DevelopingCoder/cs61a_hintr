class Comment < ActiveRecord::Base
    
    def score
        self.upvotes - self.downvotes
    end
    
end
