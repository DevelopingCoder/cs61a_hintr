class Message < ActiveRecord::Base
    validates :content, presence: true
    has_many :votes, dependent: :destroy
    has_many :users, :through => :votes
    
    def vote(user_id, vote_type)
        current_vote = self.votes.where(:user_id => user_id)
        if not current_vote.exists?
            current_vote = self.votes.create(:user_id => user_id, :vote_type => vote_type)
        elsif current_vote.first.vote_type != vote_type
            # only change vote if it's different from your first vote
            current_vote.first.update_attribute(:vote_type, vote_type)
        end
    end
    
    def upvotes
        return self.votes.where(:vote_type => 1).size
    end
    
    def downvotes
        return self.votes.where(:vote_type => -1).size
    end
    
    def finalizable
        if (self.upvotes.to_i >= MessagesController.threshold.to_i) and not self.finalized
            return true
        else
            return false
        end
    end
    
    def finalize
        concept = Concept.find(self.concept_id)
        last_assigned_message = concept.assigned_message
        if last_assigned_message
            last_assigned_message.update_attribute(:finalized, false)
        end
        self.update_attribute(:finalized, true)
        concept.update_attribute(:msg_status, "assigned")
    end
    
    def unfinalize
        concept = Concept.find(self.concept_id)
        if self.finalized
            self.update_attribute(:finalized, false)
        end
        concept.update_status
    end
    
end